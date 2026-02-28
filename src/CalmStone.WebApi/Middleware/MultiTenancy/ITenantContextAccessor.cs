namespace Api.Middleware.MultiTenancy
{
    public interface ITenantContextAccessor
    {
        TenantContext? Current { get; set; }
    }
}