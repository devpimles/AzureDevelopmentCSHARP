namespace Api.Middleware.MultiTenancy
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public sealed class AllowAnonymousTenantAttribute : Attribute
    {
    }
}