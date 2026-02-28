using Api.Controllers;
using Api.Middleware.MultiTenancy;
using CalmStone.Models.Onboarding;
using CalmStone.Services.Onboarding;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace CalmStone.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TenantsController : ControllerBase
    {
        private readonly ILogger<TenantsController> _logger;

        public TenantsController(ILogger<TenantsController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        [AllowAnonymousTenant]
        public async Task<IReadOnlyList<Tenant>> GetAllTenants()
        {
            var tenants = await new TenantService().GetAllAsync();
            return await new TenantService().GetAllAsync();
        }

        //[HttpGet]
        //[AllowAnonymousTenant]
        //public IActionResult Get()
        //{
        //    _logger.LogWarning("HealthController WARNING");
        //    _logger.LogInformation("HealthController endpoint called.");

        //    return Ok(new
        //    {
        //        status = "ok",
        //        service = "api",
        //        timestamp = DateTime.UtcNow
        //    });
        //}
    }
}
