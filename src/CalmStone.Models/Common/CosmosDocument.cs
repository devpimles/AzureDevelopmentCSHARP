namespace CalmStone.Core.Common
{
    public abstract class CosmosDocument
    {
        public string Id { get; set; } = default!;
        
        public DateTime CreatedUtc { get; set; }
        public DateTime? ModifiedUtc { get; set; }

        public string? CreatedBy { get; set; }
        public string? ModifiedBy { get; set; }
    }
}