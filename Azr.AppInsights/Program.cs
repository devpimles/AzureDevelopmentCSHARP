using Azr.AppInsights;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Configuration;
using System.Diagnostics;

// Load secrets
var configBuilder = new ConfigurationBuilder().AddUserSecrets<Program>();
var config = configBuilder.Build();
var connectionString = config["ApplicationInsights:ConnectionString"];
Console.WriteLine($"Connection string: {connectionString}");

// Create run ID for grouping
var runId = Guid.NewGuid().ToString();

// AI configuration
var aiConfig = TelemetryConfiguration.CreateDefault();
aiConfig.ConnectionString = connectionString;
aiConfig.TelemetryInitializers.Add(
    new ProcessRunTelemetryInitializer(runId, "Application Insights Demo")
);

// Create client
var telemetry = new TelemetryClient(aiConfig);

Console.WriteLine("Sending trace to Application Insights...");
Console.WriteLine($"Run ID ]{runId}[");

// Example traces
var count = new Random().Next(100, 501);
for (int i = 0; i < count; i++)
{
    telemetry.TrackTrace(
        $"Trace {i + 1} of {count}",
        Microsoft.ApplicationInsights.DataContracts.SeverityLevel.Information
    );
}

// Example exception
try
{
    throw new Exception("Test exception for AI");
}
catch (Exception ex)
{
    telemetry.TrackException(ex);
}

// Flush
telemetry.Flush();
await Task.Delay(2000);