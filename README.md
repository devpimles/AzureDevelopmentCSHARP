## Implement Azure security
### Implement user authentication and authorization
- #### Implement solutions that interact with Microsoft Graph
- [Entra ID Application](Azr.Entra)
### Implement secure Azure solutions
- #### Secure app configuration data by using Azure App Configuration or Azure Key Vault
- [App Configuration + Key Vault](Azr.AppConfig.KV/infra)
-- Creates secure, hierarchical configuration management.
## Monitor and troubleshoot Azure solutions
### Monitor and troubleshoot solutions by using Application Insights
- #### Instrument an app or service to use Application Insights
- [Application Insights + Log Analytics](Azr.AppInsights)
-- Creates an Log Analytics Workspace and Application Insights.
## Connect to and consume Azure services and third-party services
### Implement Azure API Management
- #### Create an Azure API Management instance
- [APIM](Azr.Apim/infra)
-- Creates an API Management with rate limiting policy.
### Develop message-based solutions
- #### Implement solutions that use Azure Service Bus
- [Service Bus](Azr.SvcBus.Msging)
-- Messaging Features Demo 
## Generative AI
- [AI Foundry](Azr.AIFoundry/infra)
-- Creates an Foundry account, an associated Project, and an optional model deployment.




# Prerequisites

- Azure Subscription 
-- You must have access to an active Azure subscription where resources can be deployed.
- Visual Studio Code
-- Download: https://code.visualstudio.com/
- Azure CLI
-- https://learn.microsoft.com/cli/azure/install-azure-cli

### VS Code Extensions

- Bicep
-- Adds syntax highlighting, completions, errors, and ARM template previews.
- PowerShell
-- Required to run deploy.ps1 and support "Run Selection" with F8.
- Azure CLI Tools (optional but recommended)
-- Helps with CLI syntax and IntelliSense.
