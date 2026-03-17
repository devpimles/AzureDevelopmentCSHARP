using System.Text.Json.Serialization;

namespace CalmStone.Core.Enums
{
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum TenantPlanEnum
    {
        Free,
        Basic,
        Premium
    }
}
