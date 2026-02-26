namespace Api.Middleware.MultiTenancy
{
    /// <summary>
    /// Tenant resolved per request
    /// Tenant required before controllers run
    /// Token-ready, gateway-ready
    /// </summary>
    public sealed class TenantResolutionMiddleware : IMiddleware
    {
        private readonly ITenantContextAccessor _accessor;

        public TenantResolutionMiddleware(ITenantContextAccessor accessor)
        {
            _accessor = accessor;
        }

        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            var endpoint = context.GetEndpoint();

            if (endpoint?.Metadata.GetMetadata<AllowAnonymousTenantAttribute>() != null)
            {
                await next(context);
                return;
            }

            var tenantId = ResolveTenantId(context);

            if (string.IsNullOrWhiteSpace(tenantId))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsync(
                    "Tenant is required. Provide claim 'tenant_id' or header 'X-Tenant-Id'.");
                return;
            }

            if (!Guid.TryParse(tenantId, out _))
            {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
                await context.Response.WriteAsync("TenantId must be a valid GUID.");
                return;
            }

            _accessor.Current = new TenantContext
            {
                TenantId = tenantId
            };

            context.Items["TenantId"] = tenantId;

            await next(context);
        }

        private static string? ResolveTenantId(HttpContext context)
        {
            // 1️⃣ Token claim (future)
            var claimTenant = context.User?.FindFirst("tenant_id")?.Value;
            if (!string.IsNullOrWhiteSpace(claimTenant))
                return claimTenant.Trim();

            // 2️⃣ Forwarded header (future APIM/AppGW)
            if (context.Request.Headers.TryGetValue("X-Forwarded-Tenant", out var forwarded))
            {
                var value = forwarded.FirstOrDefault();
                if (!string.IsNullOrWhiteSpace(value))
                    return value.Trim();
            }

            // 3️⃣ Direct header (today)
            if (context.Request.Headers.TryGetValue("X-Tenant-Id", out var header))
            {
                var value = header.FirstOrDefault();
                if (!string.IsNullOrWhiteSpace(value))
                    return value.Trim();
            }

            return null;
        }
    }
}