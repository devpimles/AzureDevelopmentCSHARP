using CalmStone.Core.Enums;
using CalmStone.Core.Common;

namespace CalmStone.Core.Onboarding
{
    public abstract class OnboardingDocument: CosmosDocument
    {
        public string TenantId { get; set; } = default!;
        public OnboardingEntityTypeEnum Type { get; protected set; }
    }
}