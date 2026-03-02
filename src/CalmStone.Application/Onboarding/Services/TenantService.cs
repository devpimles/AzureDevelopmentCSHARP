using CalmStone.Application.Onboarding.Interfaces;
using CalmStone.Application.Onboarding.Queries;
using CalmStone.Core.Onboarding;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CalmStone.Application.Onboarding.Services
{
    public class TenantService : ITenantService
    {
        private readonly ITenantRepository _tenantRepository;

        private static readonly List<Tenant> _tenants = new()
        {
            new Tenant("tenant-abc")
            {
                Id = "tenant-abc",
                Name = "Acme Corp",
                Plan = "pro",
                Status = "active",
                CreatedUtc = DateTime.UtcNow.AddDays(-10)
            },
            new Tenant("tenant-beta")
            {
                Id = "tenant-beta",
                Name = "Beta Industries",
                Plan = "free",
                Status = "active",
                CreatedUtc = DateTime.UtcNow.AddDays(-5)
            }
        };

        public TenantService(ITenantRepository tenantRepository)
        {
            _tenantRepository = tenantRepository;
        }

        public Task<IReadOnlyList<TenantSummary>> GetTenantSummariesAsync(CancellationToken cancellationToken)
        {
            throw new NotImplementedException();
        }

    }
}