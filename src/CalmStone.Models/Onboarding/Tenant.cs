namespace CalmStone.Models.Onboarding
{
    public class Tenant: OnboardingDocument
    {
        public string Name { get; set; } = default!;
        public string Plan { get; set; } = default!;
        public string Status { get; set; } = default!;
    }
}