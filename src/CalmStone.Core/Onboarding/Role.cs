namespace CalmStone.Core.Onboarding
{
    public class Role : OnboardingDocument
    {

        public Role(string tenantId) : base(tenantId)
        {
            
        }

        public string Name { get; set; } = default!;
        public List<string> Permissions { get; set; } = [];
    }
}