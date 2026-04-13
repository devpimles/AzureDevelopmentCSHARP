# Azure AI Foundry Minimal Deployment

This folder contains a compact Bicep-based deployment for Azure AI Foundry. It creates a Foundry account, an associated project, and can include a model deployment for quick experimentation.

![Configuration Diagram](AIFoundry_diagram.png)

## Resources Deployed

- **AI Foundry account** (`Microsoft.CognitiveServices/accounts`)
- **AI project** (`Microsoft.CognitiveServices/accounts/projects`)
- **Model deployment** (`Microsoft.CognitiveServices/accounts/deployments`)

## Files

```text
infra/
|-- README.md
|-- deploy_template.ps1
|-- main.bicep
|-- main.dev.bicepparam
`-- modules/
    `-- aifoundry.bicep
```

## Parameters

| Name | Default | Description |
|------|----------|-------------|
| `aiFoundryName` | `'uniquename'` | Name of the Foundry account |
| `aiProjectName` | `'${aiFoundryName}-proj'` | Name of the AI project |
| `location` | `'eastus2'` | Azure region |

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)
- PowerShell

The deployment script expects `SUBSCRIPTION_ID` to exist in your environment.

## Quick Start

From this folder:

```powershell
.\deploy_template.ps1
```

The script creates the resource group, deploys `main.bicep`, and prints the account keys and endpoint.

## Test the Model with LangChain

```python
from langchain_azure_ai.chat_models import AzureAIChatCompletionsModel

def foundry_model(question: str):
    llm = AzureAIChatCompletionsModel(
        endpoint=os.getenv("AZURE_INFERENCE_ENDPOINT"),
        credential=os.getenv("AZURE_INFERENCE_CREDENTIAL"),
        model="gpt-4o-mini"
    )
    messages = [
        SystemMessage(content="Calculate the optimal strategy to reduce carbon emissions in urban areas."),
        HumanMessage(content=question)
    ]
    response = llm.invoke(messages)
    print(response)
```
