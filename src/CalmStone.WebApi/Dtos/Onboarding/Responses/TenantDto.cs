namespace CalmStone.WebApi.Dtos.Onboarding.Responses
{
    public class TenantDto
    {
        public string Name { get; set; } = default!;
        public string Plan { get; set; } = default!;
        public string Status { get; set; } = default!;
        public TenantOwnerInfoDto OwnerInfo { get; set; } = default!;
    }
}
