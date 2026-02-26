namespace Api.Middleware.MultiTenancy
{
    public sealed class TenantContext
    {
        public required string TenantId { get; init; }
    }
}
