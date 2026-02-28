using CalmStone.Application.Onboarding.Queries;
using CalmStone.WebApi.Dtos.Onboarding.Responses;

namespace CalmStone.WebApi.Mapping.Onboarding
{
    public static class TenantMappings
    {
        public static TenantDto ToDto(this TenantSummary summary)
        {
            return new TenantDto
            {
                Name   = summary.Name,
                Plan   = summary.Plan,
                Status = summary.Status,
                OwnerInfo = new TenantOwnerInfoDto
                {
                    Email     = summary.OwnerEmail,
                    Provider  = summary.OwnerProvider,
                    FirstName = summary.OwnerFirstName,
                    LastName  = summary.OwnerLastName
                }
            };
        }
    }
}
