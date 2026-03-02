using System.Text.Json.Serialization;

namespace CalmStone.Core.Enums
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum OnboardingEntityTypeEnum
    {
        Tenant,
        User,
        Membership,
        Role
    }
}