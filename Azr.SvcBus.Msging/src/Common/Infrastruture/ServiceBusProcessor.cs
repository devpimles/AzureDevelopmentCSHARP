using Azure.Messaging.ServiceBus;
using Common.Messaging;

namespace Common.Infrastruture;

public class ServiceBusProcessorWrapper<T> : IMessageProcessor<T>, IAsyncDisposable
{
    private readonly ServiceBusProcessor _processor;

    public ServiceBusProcessorWrapper(ServiceBusClientFactory factory, string entityName)
    {
        _processor = factory.GetOrCreateProcessor(entityName, new ServiceBusProcessorOptions
        {
            AutoCompleteMessages = false,
            MaxConcurrentCalls = 1
        });
    }

    public async Task StartAsync(Func<T, Task> handler, CancellationToken cancellationToken = default)
    {
        _processor.ProcessMessageAsync += async args =>
        {
            try
            {
                var body = args.Message.Body.ToObjectFromJson<T>();
                await handler(body);
                await args.CompleteMessageAsync(args.Message, cancellationToken);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing message: {ex.Message}");
                try
                {
                    await args.AbandonMessageAsync(args.Message, cancellationToken: cancellationToken);
                }
                catch (Exception abandonEx)
                {
                    Console.WriteLine($"Failed to abandon message: {abandonEx.Message}");
                }
            }
        };

        _processor.ProcessErrorAsync += args =>
        {
            Console.WriteLine($"Service Bus error: {args.Exception}");
            Console.WriteLine($"Error Source: {args.ErrorSource}");
            Console.WriteLine($"Entity Path: {args.EntityPath}");
            Console.WriteLine($"FullyQualifiedNamespace: {args.FullyQualifiedNamespace}");
            return Task.CompletedTask;
        };

        await _processor.StartProcessingAsync(cancellationToken);
    }

    public async Task StopAsync() => await _processor.StopProcessingAsync();

    public async ValueTask DisposeAsync() => await _processor.DisposeAsync();
}