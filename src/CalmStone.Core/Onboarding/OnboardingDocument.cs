using CalmStone.Core.Common.Persistence;

namespace CalmStone.Core.Onboarding
{
    /// <summary>
    /// Base class for onboarding entities scoped per tenant.
    /// </summary>
    public abstract class OnboardingDocument : CosmosDocument
    {
        protected OnboardingDocument(string tenantId)
        {
            PartitionKey = tenantId;
        }

        /// <summary>
        /// Domain-friendly alias.
        /// </summary>
        public string TenantId => PartitionKey;
    }
}