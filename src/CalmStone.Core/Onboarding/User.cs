namespace CalmStone.Core.Onboarding
{

    public class User : OnboardingDocument
    {

        public User(string tenantId) : base(tenantId)
        {

        }

        public string Provider { get; set; } = default!;

        public string ProviderUserId { get; set; } = default!;

        public string Email { get; set; } = default!;

        public string? FirstName { get; set; }

        public string? LastName { get; set; }

        public string? DisplayName { get; set; }

        public string? Country { get; set; }

        public string? Locale { get; set; }

        public string? AvatarUrl { get; set; }
    }
}