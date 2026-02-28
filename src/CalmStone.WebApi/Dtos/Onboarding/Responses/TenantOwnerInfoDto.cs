namespace CalmStone.WebApi.Dtos.Onboarding.Responses
{
    public class TenantOwnerInfoDto
    {
        public string Provider { get; set; } = default!;
        public string Email { get; set; } = default!;
        public string? DisplayName { get; set; }
    }
}
