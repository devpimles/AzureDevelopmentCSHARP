using CalmStone.Application.Onboarding.Queries;
using CalmStone.Core.Onboarding;


namespace CalmStone.Application.Onboarding.Services
{
    public interface ITenantService
    {
        Task<IReadOnlyList<TenantSummary>> GetTenantSummariesAsync(CancellationToken cancellationToken);
    }
}