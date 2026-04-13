# Azure Development C#

This repository is a collection of Azure-focused labs and demos. Each module explores one service or pattern, and most of them follow the same structure:

- sample code at the module root or in `src`
- infrastructure assets in `infra`
- Bicep as the main IaC format when the module uses Bicep
- PowerShell as the orchestration layer when a deployment script is needed

## Repository Structure

| Module | Focus | Code | Infrastructure |
|---|---|---|---|
| [Azr.Entra](Azr.Entra) | Microsoft Entra ID, OAuth2, app roles, groups | Client sample + solution | [infra](Azr.Entra/infra) |
| [Azr.AppConfig.KV](Azr.AppConfig.KV) | Azure App Configuration and Key Vault | Infra-focused demo | [infra](Azr.AppConfig.KV/infra) |
| [Azr.AppInsights](Azr.AppInsights) | Application Insights and Log Analytics | Console telemetry sample | [infra](Azr.AppInsights/infra) |
| [Azr.Apim](Azr.Apim) | Azure API Management | ASP.NET API + console client | [infra](Azr.Apim/infra) |
| [Azr.SvcBus.Msging](Azr.SvcBus.Msging) | Azure Service Bus messaging patterns | Multi-project messaging demo | [infra](Azr.SvcBus.Msging/infra) |
| [Azr.AIFoundry](Azr.AIFoundry) | Azure AI Foundry basics | Infra-focused demo | [infra](Azr.AIFoundry/infra) |

## Common Module Pattern

Most modules are organized like this:

```text
ModuleName/
|-- README.md
|-- src/ or solution files
`-- infra/
    |-- README.md
    |-- main.bicep
    |-- main.dev.bicepparam
    `-- deploy.ps1
```

This makes it easier to explore each topic independently while keeping the deployment flow familiar from module to module.

## Modules

### Identity and Security

- [Azr.Entra](Azr.Entra)
  Microsoft Entra ID playground for app registrations, delegated scopes, app roles, groups, and Graph-based automation.
- [Azr.AppConfig.KV](Azr.AppConfig.KV)
  Secure configuration demo with Azure App Configuration, Key Vault, and Key Vault references.

### Monitoring and Diagnostics

- [Azr.AppInsights](Azr.AppInsights)
  Sends custom telemetry to Application Insights and provisions the related monitoring resources.

### Integration and Messaging

- [Azr.Apim](Azr.Apim)
  API Management exploration with a sample API backend and infrastructure definitions.
- [Azr.SvcBus.Msging](Azr.SvcBus.Msging)
  Messaging demo covering topics, subscriptions, queues, routing rules, and chained processing.

### AI

- [Azr.AIFoundry](Azr.AIFoundry)
  Minimal Azure AI Foundry deployment with a project and optional model deployment.

## Prerequisites

- Azure subscription with permission to create resource groups and deploy resources
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Visual Studio Code](https://code.visualstudio.com/)
- PowerShell 7 or Windows PowerShell for the PowerShell-based deployment flows
- [Bicep tools](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) for modules that use Bicep
- .NET SDK for the modules that contain application code

## Suggested Reading Flow

1. Start here to choose a module.
2. Open the module README to understand the scenario and sample code.
3. Open the module `infra/README.md` when you are ready to deploy or inspect resource details.

## Notes

- This repository mixes polished demos with exploratory work, so some modules are more app-focused while others are mostly infra-focused.
- The README updates are centered on discoverability and navigation so the existing code and diagrams remain easy to reuse.
