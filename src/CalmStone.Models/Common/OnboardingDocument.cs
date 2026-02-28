using CalmStone.Core.Enums;
using CalmStone.Models.Common;

namespace CalmStone.Models.Onboarding
{
    public abstract class OnboardingDocument: CosmosDocument
    {
        public string TenantId { get; set; } = default!;
        public OnboardingEntityTypeEnum Type { get; protected set; }
    }
}