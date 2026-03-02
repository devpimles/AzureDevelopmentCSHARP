using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Options;

namespace CalmStone.Infrastructure.Cosmos
{
    public sealed class CosmosContainerFactory : ICosmosContainerFactory
    {
        private readonly CosmosClient _client;
        private readonly CosmosDbSettings _settings;

        public CosmosContainerFactory(
            CosmosClient client,
            IOptions<CosmosDbSettings> options)
        {
            _client = client;
            _settings = options.Value;
        }

        public Container GetContainer(string logicalName)
        {
            if (!_settings.Containers.TryGetValue(logicalName, out var meta))
                throw new InvalidOperationException(
                    $"Container '{logicalName}' not configured.");

            return _client.GetContainer(
                _settings.DatabaseName,
                meta.Name);
        }
    }
}