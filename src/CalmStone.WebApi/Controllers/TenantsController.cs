using CalmStone.Application.Onboarding.Services;
using CalmStone.WebApi.Dtos.Onboarding.Responses;
using CalmStone.WebApi.Mapping.Onboarding;
using Microsoft.AspNetCore.Mvc;

namespace CalmStone.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TenantsController : ControllerBase
    {
        private readonly ITenantService _tenantService;

        public TenantsController(ITenantService tenantService)
        {
            _tenantService = tenantService;
        }

        /// <summary>
        /// GET /api/tenants/summary
        /// Returns a summary of all tenants with their owner information.
        /// </summary>
        [HttpGet("summary")]
        public async Task<ActionResult<IReadOnlyList<TenantDto>>> GetSummary(CancellationToken cancellationToken)
        {
            var summaries = await _tenantService.GetTenantSummariesAsync(cancellationToken);
            var result = summaries.Select(s => s.ToDto()).ToList();
            return Ok(result);
        }
    }
}
