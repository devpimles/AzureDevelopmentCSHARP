using CalmStone.Application.Onboarding.Interfaces;
using CalmStone.Infrastructure.Persistence.Repositories;
using Microsoft.Extensions.DependencyInjection;

namespace CalmStone.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services)
        {
            services.AddScoped<ITenantRepository, TenantRepository>();
            return services;
        }
    }
}
