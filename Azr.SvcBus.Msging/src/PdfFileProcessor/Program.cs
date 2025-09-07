using Azure.Messaging.ServiceBus;
using Common.Infrastruture;
using Common.Messaging.Messages;
using Microsoft.Extensions.Configuration;
using System.Diagnostics;

var config = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .Build();

string connectionString = config["ServiceBus:ConnectionString"] ?? throw new InvalidOperationException("Missing ServiceBus:ConnectionString");
string topicName = config["ServiceBus:TopicName"] ?? throw new InvalidOperationException("Missing ServiceBus:TopicName");
string subscriptionName = config["ServiceBus:SubscriptionName"] ?? throw new InvalidOperationException("Missing ServiceBus:SubscriptionName");
string entityTopicPath = $"{topicName}/subscriptions/{subscriptionName}";
string queueName = config["ServiceBus:QueueName"] ?? throw new InvalidOperationException("Missing ServiceBus:QueueName");

var factory = new ServiceBusClientFactory(connectionString);
var wrapper = new ServiceBusProcessorWrapper<FileMessage>(factory, entityTopicPath);

var idleTimeout = TimeSpan.FromSeconds(5);
var lastMessageTime = Stopwatch.StartNew();
var cts = new CancellationTokenSource();

await wrapper.StartAsync(async fileMsg =>
{
    try
    {
        Console.WriteLine($"Processing file: {fileMsg.FileName}");
        var sender = factory.GetOrCreateSender(queueName);
        for (int i = 0; i < 10; i++)
        {
            var chunkMessage = new ChunkMessage(
                FileId: fileMsg.FileId,
                ChunkIndex: i,
                Text: $"Processed file: {fileMsg.FileName}"
            );
            var sbChunkMessage = new ServiceBusMessage(BinaryData.FromObjectAsJson(chunkMessage));
            await sender.SendMessageAsync(sbChunkMessage);
            Console.WriteLine("Sent Chunk message.");
            lastMessageTime.Restart();
        }
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Error processing message: {ex.Message}");
        throw;
    }
}, cts.Token);

while (!cts.IsCancellationRequested)
{
    if (lastMessageTime.Elapsed >= idleTimeout)
    {
        cts.Cancel();
    }
}

await wrapper.StopAsync();

Console.WriteLine("Processing complete.");
