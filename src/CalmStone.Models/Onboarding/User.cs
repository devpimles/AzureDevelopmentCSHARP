namespace CalmStone.Core.Onboarding
{
    /// <summary>
    /// Represents a CalmStone platform user.
    /// 
    /// IMPORTANT:
    /// - This is NOT authentication data.
    /// - Authentication is handled by external providers (Google, Microsoft, etc.).
    /// - This entity maps an external identity to a CalmStone user profile.
    /// 
    /// A user may belong to multiple tenants via Membership documents.
    /// </summary>
    public class User : OnboardingDocument
    {
        /// <summary>
        /// Authentication provider name (google, microsoft, github, local, etc.).
        /// Identifies where the identity originated.
        /// </summary>
        public string Provider { get; set; } = default!;

        /// <summary>
        /// Stable unique identifier issued by the provider.
        /// DO NOT use email as identity key — emails can change.
        /// Example: Google "sub" claim.
        /// </summary>
        public string ProviderUserId { get; set; } = default!;

        /// <summary>
        /// User email used for communication and display purposes.
        /// Not guaranteed to be immutable or unique across providers.
        /// </summary>
        public string Email { get; set; } = default!;

        /// <summary>
        /// User given name normalized by CalmStone.
        /// Providers return names differently, so we store our own copy.
        /// </summary>
        public string? FirstName { get; set; }

        /// <summary>
        /// User family name.
        /// Stored separately to allow sorting and personalization.
        /// </summary>
        public string? LastName { get; set; }

        /// <summary>
        /// Preferred display name shown in UI.
        /// Normalized value independent of provider formatting.
        /// </summary>
        public string? DisplayName { get; set; }

        /// <summary>
        /// ISO country code (e.g. PT, US, DE).
        /// Useful for billing, localization, analytics, and compliance.
        /// </summary>
        public string? Country { get; set; }

        /// <summary>
        /// UI locale preference (e.g. pt-PT, en-US).
        /// Allows future localization without additional profile tables.
        /// </summary>
        public string? Locale { get; set; }

        /// <summary>
        /// Avatar/profile image URL returned by provider or uploaded later.
        /// Stored as URL only — images belong in Blob Storage.
        /// </summary>
        public string? AvatarUrl { get; set; }
    }
}