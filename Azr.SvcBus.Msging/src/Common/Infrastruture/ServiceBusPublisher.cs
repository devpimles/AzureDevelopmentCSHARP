using Azure.Messaging.ServiceBus;
using Common.Messaging;

namespace Common.Infrastruture;

public class ServiceBusPublisher<T> : IMessagePublisher<T>
{
    private readonly ServiceBusSender _sender;

    public ServiceBusPublisher(ServiceBusClientFactory factory, string entityName)
    {
        _sender = factory.GetOrCreateSender(entityName);
    }

    public async Task PublishAsync(T message, CancellationToken cancellationToken = default)
    {
        var sbMessage = new ServiceBusMessage(BinaryData.FromObjectAsJson(message));
        await _sender.SendMessageAsync(sbMessage, cancellationToken);
    }
}

