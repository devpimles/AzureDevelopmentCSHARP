namespace CalmStone.Core.Onboarding
{
    public sealed class Tenant : OnboardingDocument
    {
        public Tenant(string tenantId) : base(tenantId)
        {
        }

        public string Name { get; set; } = default!;
        public string Plan { get; set; } = default!;
        public string Status { get; set; } = default!;

        // TODO: The type ?
    }
}