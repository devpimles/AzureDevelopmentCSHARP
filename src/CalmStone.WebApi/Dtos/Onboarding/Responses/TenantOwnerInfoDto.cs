namespace CalmStone.WebApi.Dtos.Onboarding.Responses
{
    public class TenantOwnerInfoDto
    {
        public string Email { get; set; } = default!;
        public string Provider { get; set; } = default!;
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
    }
}
