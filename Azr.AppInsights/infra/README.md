# Resources

![Diagram](img/ApplicationInsights-Image.png)

- Log Analytics Workspace
- Application Insights (other)

## Log Analytics Workspace

- Free

## Application Insights

Common best practice:

- One App Insights per microservice
- One App Insights per distinct component
- One App Insights per environment (dev/test/prod)

Example structure:

Component           |	App Insights        |   LAW         |
|-------------------|-----------------------|---------------|
Web API             |   ai-api-dev          |	law-dev     |
Background worker   |   ai-worker-dev       |   law-dev     |
Frontend SPA        |   ai-frontend-dev     |   law-dev     |
Container App       |   ai-container-dev    |   law-dev     |

- [FAQ Application Insights](https://docs.azure.cn/en-us/azure-monitor/app/application-insights-faq)
