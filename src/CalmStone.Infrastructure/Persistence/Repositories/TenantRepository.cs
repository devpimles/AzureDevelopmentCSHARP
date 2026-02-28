using CalmStone.Application.Onboarding.Interfaces;
using CalmStone.Application.Onboarding.Queries;

namespace CalmStone.Infrastructure.Persistence.Repositories
{
    /// <summary>
    /// In-memory implementation of ITenantRepository.
    /// Replace with a real CosmosDB implementation when ready.
    /// </summary>
    public class TenantRepository : ITenantRepository
    {
        // Simulated Cosmos DB data — tenants + their owner users
        private static readonly IReadOnlyList<TenantSummary> _data = new List<TenantSummary>
        {
            new TenantSummary
            {
                TenantId      = "tenant-abc",
                Name          = "Acme Corp",
                Plan          = "pro",
                Status        = "active",
                OwnerEmail    = "alice@acme.com",
                OwnerProvider = "google",
                OwnerFirstName = "Alice",
                OwnerLastName  = "Smith"
            },
            new TenantSummary
            {
                TenantId      = "tenant-beta",
                Name          = "Beta Industries",
                Plan          = "free",
                Status        = "active",
                OwnerEmail    = "bob@beta.io",
                OwnerProvider = "microsoft",
                OwnerFirstName = "Bob",
                OwnerLastName  = null
            }
        };

        public Task<IReadOnlyList<TenantSummary>> GetTenantSummariesAsync(CancellationToken cancellationToken)
        {
            return Task.FromResult(_data);
        }
    }
}
