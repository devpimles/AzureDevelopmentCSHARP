using Azure.Messaging.ServiceBus;

namespace Common.Infrastruture;

public class ServiceBusClientFactory : IAsyncDisposable
{
    private readonly ServiceBusClient _client;

    private readonly Dictionary<string, ServiceBusSender> _senders = [];
    private readonly Dictionary<string, ServiceBusProcessor> _processors = [];

    public ServiceBusClientFactory(string connectionString, ServiceBusClientOptions? options = null)
    {
        _client = new ServiceBusClient(connectionString, options ?? new ServiceBusClientOptions());
    }

    public ServiceBusSender GetOrCreateSender(string entityName)
    {
        return _senders.GetValueOrDefault(entityName, _client.CreateSender(entityName));
    }

    public ServiceBusProcessor GetOrCreateProcessor(string entityName, ServiceBusProcessorOptions? options = null)
    {
        return _processors.GetValueOrDefault(entityName, _client.CreateProcessor(entityName, options ?? new ServiceBusProcessorOptions()));
    }

    public async Task RemoveProcessorAsync(string entityName)
    {
        if (_processors.Remove(entityName, out var processor))
        {
            await processor.StopProcessingAsync();
            await processor.DisposeAsync();
        }
    }

    public async ValueTask DisposeAsync()
    {
        foreach (var processor in _processors.Values)
        {
            await processor.StopProcessingAsync();
            await processor.DisposeAsync();
        }

        foreach (var sender in _senders.Values)
        {
            await sender.DisposeAsync();
        }

        await _client.DisposeAsync();
    }

}
