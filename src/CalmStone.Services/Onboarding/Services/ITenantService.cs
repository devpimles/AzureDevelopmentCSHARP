using CalmStone.Application.Onboarding.Queries;
using CalmStone.Core.Onboarding;


namespace CalmStone.Application.Onboarding.Services
{
    public interface ITenantService
    {
        Task<Tenant?> GetAsync(string tenantId);

        Task<IReadOnlyList<Tenant>> GetAllAsync();

        Task<bool> TenantExistsAsync(string tenantId);

        Task<string> CreateAsync(Tenant tenant);

        Task UpdateAsync(Tenant tenant);

        Task DeleteAsync(string tenantId);

        Task<IReadOnlyList<TenantSummary>> GetTenantSummariesAsync(CancellationToken cancellationToken);
    }
}