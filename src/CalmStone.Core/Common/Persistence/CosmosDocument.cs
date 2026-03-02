namespace CalmStone.Core.Common.Persistence
{
    /// <summary>
    /// Base document persisted in Cosmos DB.
    /// Storage-agnostic domain base.
    /// </summary>
    public abstract class CosmosDocument
    {
        /// <summary>
        /// Cosmos DB requires property named "id".
        /// </summary>
        public string Id { get; set; } = default!;

        /// <summary>
        /// Logical partition key value.
        /// Meaning defined by derived domain types.
        /// </summary>
        public string PartitionKey { get; protected set; } = default!;

        public DateTime CreatedUtc { get; set; }
        public DateTime? ModifiedUtc { get; set; }

        public string? CreatedBy { get; set; }
        public string? ModifiedBy { get; set; }
    }
}