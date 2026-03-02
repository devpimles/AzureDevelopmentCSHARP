using CalmStone.Application.Common.Persistence;
using CalmStone.Core.Common.Persistence;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Logging;

namespace CalmStone.Infrastructure.Cosmos
{
    public abstract class CosmosRepository<T> : ICosmosRepository<T>
        where T : CosmosDocument
    {
        private readonly Container _container;
        private readonly ILogger _logger;

        protected CosmosRepository(
            ICosmosContainerFactory factory,
            ILogger logger)
        {
            _container = factory.GetContainer(ContainerName);
            _logger = logger;
        }

        protected abstract string ContainerName { get; }

        public async Task<T?> GetAsync(
            string id,
            string partitionKey,
            CancellationToken ct)
        {
            try
            {
                var response = await _container.ReadItemAsync<T>(
                    id,
                    new PartitionKey(partitionKey),
                    cancellationToken: ct);

                return response.Resource;
            }
            catch (CosmosException ex)
                when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                return null;
            }
        }

        public async Task UpsertAsync(T entity, CancellationToken ct)
        {
            entity.ModifiedUtc = DateTime.UtcNow;

            if (entity.CreatedUtc == default)
                entity.CreatedUtc = DateTime.UtcNow;

            try
            {
                await _container.UpsertItemAsync(
                    entity,
                    new PartitionKey(entity.PartitionKey),
                    cancellationToken: ct);
            }
            catch (CosmosException ex)
            {
                _logger.LogError(ex,
                    "Cosmos upsert failed. Diagnostics: {diag}",
                    ex.Diagnostics?.ToString());

                throw;
            }
        }

        public async Task DeleteAsync(
            string id,
            string partitionKey,
            CancellationToken ct)
        {
            await _container.DeleteItemAsync<T>(
                id,
                new PartitionKey(partitionKey),
                cancellationToken: ct);
        }
    }
}