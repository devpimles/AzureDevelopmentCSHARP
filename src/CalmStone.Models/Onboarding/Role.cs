namespace CalmStone.Core.Onboarding
{
    public class Role : OnboardingDocument
    {
        public string Name { get; set; } = default!;
        public List<string> Permissions { get; set; } = [];
    }
}