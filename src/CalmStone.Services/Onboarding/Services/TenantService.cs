using CalmStone.Models.Onboarding;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CalmStone.Application.Onboarding.Services
{
    public class TenantService : ITenantService
    {
        private static readonly List<Tenant> _tenants = new()
        {
            new Tenant
            {
                Id = "tenant-abc",
                TenantId = "tenant-abc",
                Name = "Acme Corp",
                Plan = "pro",
                Status = "active",
                CreatedUtc = DateTime.UtcNow.AddDays(-10)
            },
            new Tenant
            {
                Id = "tenant-beta",
                TenantId = "tenant-beta",
                Name = "Beta Industries",
                Plan = "free",
                Status = "active",
                CreatedUtc = DateTime.UtcNow.AddDays(-5)
            }
        };

        public Task<IReadOnlyList<Tenant>> GetAllAsync()
        {
            return Task.FromResult((IReadOnlyList<Tenant>)_tenants.ToList());
        }

        public Task<Tenant?> GetAsync(string tenantId)
        {
            var tenant = _tenants
                .FirstOrDefault(t => t.TenantId == tenantId);

            return Task.FromResult(tenant);
        }

        public Task<bool> TenantExistsAsync(string tenantId)
        {
            var exists = _tenants
                .Any(t => t.TenantId == tenantId);

            return Task.FromResult(exists);
        }

        public Task<string> CreateAsync(Tenant tenant)
        {
            tenant.Id ??= tenant.TenantId;
            tenant.CreatedUtc = DateTime.UtcNow;

            _tenants.Add(tenant);

            return Task.FromResult(tenant.TenantId);
        }

        public Task UpdateAsync(Tenant tenant)
        {
            var existing = _tenants
                .FirstOrDefault(t => t.TenantId == tenant.TenantId);

            if (existing != null)
            {
                existing.Name = tenant.Name;
                existing.Plan = tenant.Plan;
                existing.Status = tenant.Status;
                existing.ModifiedUtc = DateTime.UtcNow;
            }

            return Task.CompletedTask;
        }

        public Task DeleteAsync(string tenantId)
        {
            var tenant = _tenants
                .FirstOrDefault(t => t.TenantId == tenantId);

            if (tenant != null)
            {
                _tenants.Remove(tenant);
            }

            return Task.CompletedTask;
        }
    }
}