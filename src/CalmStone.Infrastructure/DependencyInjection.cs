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

            services.AddSingleton<CosmosClient>(sp =>
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
                else if (options.PreferredRegions.Count != 0)
                    clientOptions.ApplicationPreferredRegions = options.PreferredRegions;

                var warmup = options.WarmupContainers
                    .Select(c => (options.DatabaseName, c))
                    .ToList();

                if (warmup.Count > 0)
                {
                    return CosmosClient.CreateAndInitializeAsync(
                        options.ConnectionString,
                        warmup,
                        clientOptions
                    ).GetAwaiter().GetResult();
                }

                return new CosmosClient(options.ConnectionString, clientOptions);
            });

            services.AddSingleton<ICosmosContainerFactory, CosmosContainerFactory>();

            services.AddScoped<ITenantRepository, TenantRepository>();

            return services;
        }
    }
}