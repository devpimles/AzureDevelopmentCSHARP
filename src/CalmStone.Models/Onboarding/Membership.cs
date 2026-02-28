using CalmStone.Core.Enums;
using System.Collections.Generic;

namespace CalmStone.Models.Onboarding
{
    public class Membership: OnboardingDocument
    {
        public string UserId { get; set; } = default!;
        public List<RoleNameEnum> Roles { get; set; } = [];
    }
}