using Api.Middleware.MultiTenancy;
using Microsoft.AspNetCore.Mvc;

namespace Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HealthController : ControllerBase
    {

        private readonly ILogger<HealthController> _logger;

        public HealthController(ILogger<HealthController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        [AllowAnonymousTenant]
        public IActionResult Get()
        {
            _logger.LogWarning("HealthController WARNING");
            _logger.LogInformation("HealthController endpoint called.");

            return Ok(new
            {
                status = "ok",
                service = "api",
                timestamp = DateTime.UtcNow
            });
        }
    }
}
