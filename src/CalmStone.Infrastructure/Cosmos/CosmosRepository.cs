using CalmStone.Application.Common.Persistence;
using CalmStone.Core.Common.Persistence;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Linq;
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

        protected IQueryable<T> Query()
        {
            return _container.GetItemLinqQueryable<T>(
                allowSynchronousQueryExecution: false);
        }

        protected async Task<List<T>> ExecuteQueryAsync(
            IQueryable<T> query,
            CancellationToken ct)
        {
            var results = new List<T>();

            try
            {
                using var iterator = query.ToFeedIterator();

                while (iterator.HasMoreResults)
                {
                    var response = await iterator.ReadNextAsync(ct);

                    _logger.LogDebug(
                        "Cosmos query page RU {ru}. Container {container}",
                        response.RequestCharge,
                        ContainerName);

                    results.AddRange(response);
                }

                return results;
            }
            catch (CosmosException ex)
            {
                _logger.LogError(
                    ex,
                    "Cosmos query failed. Container: {container}. Diagnostics: {diag}",
                    ContainerName,
                    ex.Diagnostics?.ToString());

                throw;
            }
        }

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
            catch (CosmosException ex)
            {
                _logger.LogError(
                    ex,
                    "Cosmos read failed. Container: {container}. Id: {id}. PK: {pk}. Diagnostics: {diag}",
                    ContainerName,
                    id,
                    partitionKey,
                    ex.Diagnostics?.ToString());

                throw;
            }
        }

        public async Task UpsertAsync(T entity, CancellationToken ct)
        {
            entity.ModifiedUtc = DateTime.UtcNow;

            if (entity.CreatedUtc == default)
                entity.CreatedUtc = DateTime.UtcNow;

            try
            {
                var response = await _container.UpsertItemAsync(
                    entity,
                    new PartitionKey(entity.PartitionKey),
                    cancellationToken: ct);

                _logger.LogDebug(
                    "Cosmos upsert RU charge {ru}. Container {container}. Id {id}",
                    response.RequestCharge,
                    ContainerName,
                    entity.Id);
            }
            catch (CosmosException ex)
            {
                _logger.LogError(
                    ex,
                    "Cosmos upsert failed. Container: {container}. Id: {id}. PK: {pk}. Diagnostics: {diag}",
                    ContainerName,
                    entity.Id,
                    entity.PartitionKey,
                    ex.Diagnostics?.ToString());

                throw;
            }
        }

        public async Task DeleteAsync(
            string id,
            string partitionKey,
            CancellationToken ct)
        {
            try
            {
                await _container.DeleteItemAsync<T>(
                    id,
                    new PartitionKey(partitionKey),
                    cancellationToken: ct);
            }
            catch (CosmosException ex)
            {
                _logger.LogError(
                    ex,
                    "Cosmos delete failed. Container: {container}. Id: {id}. PK: {pk}. Diagnostics: {diag}",
                    ContainerName,
                    id,
                    partitionKey,
                    ex.Diagnostics?.ToString());

                throw;
            }
        }
    }
}