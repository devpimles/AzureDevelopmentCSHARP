# Azure App Configuration and Key Vault Secure Configuration Demo

This folder demonstrates secure, hierarchical configuration management in Azure using Azure App Configuration and Azure Key Vault, following a structure that maps cleanly into application settings.

![Configuration Diagram](AppConfigurationStore_KeyVault.png)

## Resources Deployed

This deployment provisions the following Azure resources using Bicep:

- **Azure App Configuration** for non-sensitive hierarchical settings such as `AI:OpenAI:ModelName`
- **Azure Key Vault** for secret management
- **RBAC-based authorization** instead of legacy access policies
- **Key Vault references** so App Configuration values can point to secrets securely

## Hierarchical Configuration Structure

Configuration keys follow a structured naming convention:

```text
AI:OpenAI:ModelName
AI:OpenAI:Temperature
AI:OpenAI:MaxTokens
AI:OpenAI:ApiKey
AI:Anthropic:ModelName
AI:Anthropic:Temperature
AI:Anthropic:MaxTokens
AI:Anthropic:ApiKey
```

These map directly to strongly typed configuration objects in application code.

## Files

```text
infra/
|-- README.md
|-- main.bicep
|-- main.dev.bicepparam
`-- modules/
    |-- appconfig.bicep
    `-- keyvault.bicep
```

## Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- [VS Code Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install)

## Deployment

### Local Development

1. Create a `.env` file in this folder or project root if your workflow needs local secret values:

```text
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-your-anthropic-key
```

2. Deploy from this folder:

```powershell
# Validate without deploying
az deployment group validate `
  --resource-group my-rg `
  --template-file .\main.bicep `
  --parameters .\main.dev.bicepparam

# Deploy infrastructure
az deployment group create `
  --resource-group my-rg `
  --template-file .\main.bicep `
  --parameters .\main.dev.bicepparam
```

### Production or CI/CD

Store secrets in secure pipeline variables or secret stores instead of local files.

## Security Best Practices

- Never hardcode secrets in `.bicepparam` files or templates
- Use `@secure()` parameters in Bicep for sensitive inputs
- Store secrets in secure platform storage outside local development
- Verify deployment with `az keyvault secret list --vault-name <vault-name> -o table`
