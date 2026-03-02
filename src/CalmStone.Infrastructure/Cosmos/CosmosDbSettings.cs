namespace CalmStone.Infrastructure.Cosmos
{
    public sealed class CosmosDbSettings
    {
        public string Endpoint { get; set; } = default!;
        public string Key { get; set; } = default!; // TODO: Needed?
        public string DatabaseName { get; set; } = default!;

        public Dictionary<string, ContainerSettings> Containers { get; set; }
            = new();
    }

    public sealed class ContainerSettings
    {
        public string Name { get; set; } = default!;
        public string PartitionKeyPath { get; set; } = default!;
    }
}