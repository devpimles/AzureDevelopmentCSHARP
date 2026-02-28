namespace CalmStone.Models.Onboarding
{
    public class Role : OnboardingDocument
    {
        public string Name { get; set; } = default!;
        public List<string> Permissions { get; set; } = [];
    }
}