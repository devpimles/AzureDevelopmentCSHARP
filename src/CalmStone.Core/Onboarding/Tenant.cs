using CalmStone.Core.Enums;

namespace CalmStone.Core.Onboarding
{
    public sealed class Tenant : OnboardingDocument
    {
        public Tenant(string tenantId) : base(tenantId)
        {
        }

        public string Name { get; set; } = default!;
        public string Description { get; set; } = default!;
        public TenantPlanEnum Plan { get; set; } = default!;
        public TenantStatusEnum Status { get; set; }

    }
}