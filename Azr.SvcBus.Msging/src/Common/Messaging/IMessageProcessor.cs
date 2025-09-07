namespace Common.Messaging;

public interface IMessageProcessor<T>
{
    Task StartAsync(Func<T, Task> handler, CancellationToken cancellationToken = default);
    Task StopAsync();
}