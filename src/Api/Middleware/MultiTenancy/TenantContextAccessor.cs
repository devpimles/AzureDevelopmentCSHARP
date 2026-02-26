namespace Api.Middleware.MultiTenancy
{
    public sealed class TenantContextAccessor : ITenantContextAccessor
    {
        public TenantContext? Current { get; set; }
    }
}