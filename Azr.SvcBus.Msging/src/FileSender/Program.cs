using Azure.Messaging.ServiceBus;
using Common.Infrastruture;
using Common.Messaging.Messages;
using Microsoft.Extensions.Configuration;

var config = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .Build();

string connectionString = config["ServiceBus:ConnectionString"] ?? throw new InvalidOperationException("Missing ServiceBus:ConnectionString");
string topicName = config["ServiceBus:TopicName"] ?? throw new InvalidOperationException("Missing ServiceBus:TopicName");

var factory = new ServiceBusClientFactory(connectionString);
var sender = factory.GetOrCreateSender(topicName);

var pdfMessage = new FileMessage(
    FileId: Guid.NewGuid().ToString(),
    FileName: "document.pdf",
    FileType: "pdf",
    StorageUrl: "https://storage.example.com/document.pdf"
);
var sbPdfMessage = new ServiceBusMessage(BinaryData.FromObjectAsJson(pdfMessage));
sbPdfMessage.ApplicationProperties["fileType"] = "pdf";

var txtMessage = new FileMessage(
    FileId: Guid.NewGuid().ToString(),
    FileName: "notes.txt",
    FileType: "txt",
    StorageUrl: "https://storage.example.com/notes.txt"
);
var sbTxtMessage = new ServiceBusMessage(BinaryData.FromObjectAsJson(txtMessage));
sbTxtMessage.ApplicationProperties["fileType"] = "txt";

await sender.SendMessageAsync(sbPdfMessage);
Console.WriteLine("Sent PDF file message.");
await sender.SendMessageAsync(sbTxtMessage);
Console.WriteLine("Sent TXT file message.");

await factory.DisposeAsync();
