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