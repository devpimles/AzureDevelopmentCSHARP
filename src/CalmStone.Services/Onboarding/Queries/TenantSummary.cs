using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CalmStone.Application.Onboarding.Queries
{
    public class TenantSummary
    {
        public string TenantId { get; init; } = default!;
        public string Name { get; init; } = default!;
        public string Plan { get; init; } = default!;
        public string Status { get; init; } = default!;
        public string OwnerEmail { get; init; } = default!;
        public string OwnerProvider { get; init; } = default!;
        public string? OwnerFirstName { get; init; }
        public string? OwnerLastName { get; init; }
    }
}
