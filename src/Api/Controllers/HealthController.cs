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
        public IActionResult Get()
        {
            _logger.LogWarning("AI TEST WARNING");
            _logger.LogInformation("Health check endpoint called.");

            return Ok(new
            {
                status = "ok",
                service = "api",
                timestamp = DateTime.UtcNow
            });
        }
    }
}
