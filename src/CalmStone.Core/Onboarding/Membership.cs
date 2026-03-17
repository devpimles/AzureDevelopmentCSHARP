using CalmStone.Core.Enums;
using System.Collections.Generic;

namespace CalmStone.Core.Onboarding
{
    public sealed class Membership : OnboardingDocument
    {
        public Membership(string tenantId) : base(tenantId)
        {
        }

        public string UserId { get; set; } = default!;
        public List<RoleNameEnum> Roles { get; set; } = [];
    }
}