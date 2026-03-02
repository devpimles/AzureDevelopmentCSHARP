using CalmStone.Application.Onboarding.Interfaces;
using CalmStone.Core.Onboarding;
using Microsoft.Extensions.Logging;

namespace CalmStone.Infrastructure.Cosmos.Onboarding
{

    public sealed class TenantRepository
        : CosmosRepository<Tenant>, ITenantRepository
    {
        public TenantRepository(
            ICosmosContainerFactory factory,
            ILogger<TenantRepository> logger)
            : base(factory, logger)
        {
        }

        protected override string ContainerName => "Onboarding";

        public Task<Tenant?> GetAsync(string tenantId, string id, CancellationToken ct)
            => base.GetAsync(id, tenantId, ct);

        public Task UpsertAsync(Tenant tenant, CancellationToken ct)
            => base.UpsertAsync(tenant, ct);
    }
}