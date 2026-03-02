using CalmStone.Application.Onboarding.Queries;
using CalmStone.Core.Onboarding;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CalmStone.Application.Onboarding.Interfaces
{
    public interface ITenantRepository
    {
        Task<Tenant?> GetAsync(string tenantId, string id, CancellationToken ct);
        Task UpsertAsync(Tenant tenant, CancellationToken ct);
    }
}
