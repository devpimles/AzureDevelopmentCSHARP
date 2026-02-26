using Api.Middleware.MultiTenancy;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TenantController : ControllerBase
    {

        private readonly ILogger<TenantController> _logger;
        private readonly ITenantContextAccessor _tenant;

        public TenantController(ILogger<TenantController> logger, ITenantContextAccessor tenant)
        {
            _logger = logger;
            _tenant = tenant;
        }

        [HttpGet]
        public IActionResult Get()
        {
            _logger.LogWarning("TenantController WARNING");
            _logger.LogInformation("TenantController endpoint called.");

            return Ok(new
            {
                tenantId = _tenant.Current?.TenantId,
                timestamp = DateTime.UtcNow
            });

        }

    }
}
