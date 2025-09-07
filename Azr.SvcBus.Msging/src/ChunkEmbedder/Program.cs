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
string queueName = config["ServiceBus:QueueName"] ?? throw new InvalidOperationException("Missing ServiceBus:QueueName");

var factory = new ServiceBusClientFactory(connectionString);
var wrapper = new ServiceBusProcessorWrapper<ChunkMessage>(factory, queueName);

var idleTimeout = TimeSpan.FromSeconds(5);
var lastMessageTime = Stopwatch.StartNew();
var cts = new CancellationTokenSource();

await wrapper.StartAsync(async chunkMsg =>
{
    try
    {
        Console.WriteLine($"Processing chunk {chunkMsg.ChunkIndex} file {chunkMsg.FileId}");
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
