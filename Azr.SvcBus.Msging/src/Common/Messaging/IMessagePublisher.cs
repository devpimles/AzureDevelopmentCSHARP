namespace Common.Messaging;

public interface IMessagePublisher<T>
{
    Task PublishAsync(T message, CancellationToken cancellationToken = default);
}