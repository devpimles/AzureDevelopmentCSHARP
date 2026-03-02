using CalmStone.Application.Onboarding.Interfaces;
using CalmStone.Infrastructure.Cosmos;
using CalmStone.Infrastructure.Cosmos.Onboarding;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace CalmStone.Infrastructure
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services)
        {
            services
                .AddOptions<CosmosOptions>()
                .BindConfiguration(CosmosOptions.SectionName)
                .ValidateDataAnnotations()
                .ValidateOnStart();

            services.AddSingleton(sp =>
            {
                var options = sp.GetRequiredService<IOptions<CosmosOptions>>().Value;

                var clientOptions = new CosmosClientOptions
                {
                    ConnectionMode = ConnectionMode.Direct,
                    SerializerOptions = new CosmosSerializationOptions
                    {
                        PropertyNamingPolicy = CosmosPropertyNamingPolicy.CamelCase
                    }
                };

                if (!string.IsNullOrWhiteSpace(options.ApplicationRegion))
                    clientOptions.ApplicationRegion = options.ApplicationRegion;
                else if (options.PreferredRegions.Count > 0)
                    clientOptions.ApplicationPreferredRegions = options.PreferredRegions;

                var containers = options.WarmupContainers
                    .Select(c => (options.DatabaseName, c))
                    .ToList();

                return containers.Count > 0
                    ? CosmosClient.CreateAndInitializeAsync(
                        options.AccountEndpoint,
                        options.AccountKey,
                        containers,
                        clientOptions)
                      .GetAwaiter().GetResult()
                    : new CosmosClient(
                        options.AccountEndpoint,
                        options.AccountKey,
                        clientOptions);
            });

            services.AddSingleton<ICosmosContainerFactory, CosmosContainerFactory>();

            services.AddScoped<ITenantRepository, TenantRepository>();

            return services;
        }
    }
}