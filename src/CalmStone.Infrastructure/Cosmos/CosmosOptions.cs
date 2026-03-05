using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CalmStone.Infrastructure.Cosmos
{
    
    public sealed class CosmosOptions
    {
        public const string SectionName = "Cosmos";
        [Required]
        public string ConnectionString { get; init; } = default!;
        [Required]
        public string DatabaseName { get; init; } = default!;

        public string? ApplicationRegion { get; init; }

        public List<string> PreferredRegions { get; init; } = new();

        public List<string> WarmupContainers { get; init; } = new();
    }
}
