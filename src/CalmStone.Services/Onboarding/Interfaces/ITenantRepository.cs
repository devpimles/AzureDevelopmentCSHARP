using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CalmStone.Application.Onboarding.Queries;

namespace CalmStone.Application.Onboarding.Interfaces
{
    public interface ITenantRepository
    {
        Task<IReadOnlyList<TenantSummary>> GetTenantSummariesAsync(CancellationToken cancellationToken);
    }
}
