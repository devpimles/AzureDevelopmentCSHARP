using CalmStone.Application.Onboarding.Services;
using Microsoft.Extensions.DependencyInjection;

namespace CalmStone.Application
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApplication(this IServiceCollection services)
        {
            services.AddScoped<ITenantService, TenantService>();
            return services;
        }
    }
}
