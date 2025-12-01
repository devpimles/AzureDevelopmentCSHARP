using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace Azr.AppInsights
{
    public class ProcessRunTelemetryInitializer : ITelemetryInitializer
    {
        private readonly string _runId;
        private readonly string _appName;

        public ProcessRunTelemetryInitializer(string runId, string appName)
        {
            _runId = runId;
            _appName = appName;
        }

        public void Initialize(ITelemetry telemetry)
        {
            telemetry.Context.GlobalProperties["RunId"] = _runId;
            telemetry.Context.GlobalProperties["ApplicationName"] = _appName;
        }
    }
}
