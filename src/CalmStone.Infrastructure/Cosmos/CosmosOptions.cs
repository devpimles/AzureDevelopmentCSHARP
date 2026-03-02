using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CalmStone.Infrastructure.Cosmos
{
    
    public sealed class CosmosOptions
    {
        public const string SectionName = "Cosmos";

        public string AccountEndpoint { get; init; } = string.Empty;

        public string AccountKey { get; init; } = string.Empty;

        public string DatabaseName { get; init; } = string.Empty;

        public string? ApplicationRegion { get; init; }

        public List<string> PreferredRegions { get; init; } = [];

        public List<string> WarmupContainers { get; init; } = [];
    }
}
