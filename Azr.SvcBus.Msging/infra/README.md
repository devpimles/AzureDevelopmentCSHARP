# Azure Service Bus - Messaging Features Demo - Infrastructure

This repository contains Azure Resource Manager (ARM) templates and deployment scripts to provision Azure Service Bus resources.

## Overview

This template deploys the following Azure Service Bus infrastructure:
- **Azure Service Bus Namespace** (Standard tier)
- **File Topic** for file processing workflow
  - **Txt File Receiver** (subscription with filter for txt files)
  - **Pdf File Receiver** (subscription with filter for pdf files)
- **Chunk Queue** for chunk processing

## Architecture

```
File Sender → File Topic → Txt File Receiver (fileType = 'txt')
                      → Pdf File Receiver (fileType = 'pdf')

Chunk Queue ← Chunk Receiver
```

**Workflow:**
1. **File Sender** publishes messages to **File Topic**
2. **File Topic** routes messages to appropriate receivers based on file type:
   - Messages with `fileType = 'txt'` → **Txt File Receiver**
   - Messages with `fileType = 'pdf'` → **Pdf File Receiver**
3. **Chunk Receiver** processes messages from **Chunk Queue**

## Prerequisites

- Azure CLI installed and configured
- An active Azure subscription
- Bash shell environment (WSL, Git Bash, or Linux/macOS terminal)

## Quick Start

### Prerequisites Setup

1. **Ensure Azure CLI is installed**:
   ```bash
   az --version
   ```

2. **Login to Azure**:
   ```bash
   az login
   ```

### Deploy Infrastructure

1. **Clone or download** the repository
2. **Navigate** to the infrastructure directory:
   ```bash
   cd infra
   ```
3. **Deploy the infrastructure**:
   ```bash
   ./deploy_template.sh
   ```

## Files Structure

```
infra/
├── azuredeploy.json              # ARM template
├── azuredeploy.parameters.json   # Template parameters
├── deploy_template.sh            # Deployment script
└── README.md                     # This file
```

## Template Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `serviceBusNamespaceName` | string | Name of the Service Bus namespace | `demo-servicebus-ns-20250826` |
| `fileTopicName` | string | Name of the file topic | `file-topic` |
| `chunkQueueName` | string | Name of the chunk queue | `chunk-queue` |
| `location` | string | Azure region for deployment | `westeurope` |

## Configuration

The deployment uses hardcoded configuration values:

```bash
# Project Configuration
resourceGroupName="rg-demo"      # Resource group name
location="westeurope"            # Azure region
deploymentName="servicebus-demo-{timestamp}"  # Deployment name with unique suffix

# Template Files
templateFile="azuredeploy.json"              # ARM template
parametersFile="azuredeploy.parameters.json" # Parameters
```

### Customizing Configuration

To modify the deployment configuration, edit the variables at the top of `deploy_template.sh`:

```bash
# Demo configuration
resourceGroupName="rg-demo"
location="westeurope"
templateFile="azuredeploy.json"
parametersFile="azuredeploy.parameters.json"
```

You can also modify the parameter values in `azuredeploy.parameters.json`:

```json
{
  "parameters": {
    "serviceBusNamespaceName": { "value": "your-namespace-name" },
    "serviceBusQueueName": { "value": "your-queue-name" },
    "location": { "value": "your-region" }
  }
}
```

## Deployment

### Automatic Deployment

The deployment script (`deploy_template.sh`) performs the following steps:

1. **Resource Group Creation**: Creates `rg-demo` resource group
2. **ARM Template Deployment**: Deploys the Service Bus infrastructure
3. **Connection String Display**: Shows the root connection string after deployment

### Manual Deployment

You can also deploy manually using Azure CLI:

```bash
# Create resource group
az group create --name "rg-demo" --location "westeurope"

# Deploy template
az deployment group create \
  --name "servicebus-deployment" \
  --resource-group "rg-demo" \
  --template-file "azuredeploy.json" \
  --parameters "@azuredeploy.parameters.json"
```

## Outputs

After successful deployment, you'll have:
- A Service Bus namespace with Standard tier
- A file topic with filtered subscriptions for txt and pdf file processing
- A chunk queue for chunk processing workflow
- A root connection string for accessing the namespace

**Resources Created:**
- **Namespace**: `demo-servicebus-ns-20250826`
- **File Topic**: `file-topic`
  - **TxtFileReceiver** subscription (filters messages where `fileType = 'txt'`)
  - **PdfFileReceiver** subscription (filters messages where `fileType = 'pdf'`)
- **Chunk Queue**: `chunk-queue`
- **Authorization Rule**: `RootSharedAccessKey`

### Getting Connection String

The deployment script automatically displays the root connection string at the end. You can also retrieve it manually:

```bash
# Get the connection string from the deployment
az deployment group show \
  --name "your-deployment-name" \
  --resource-group "rg-demo" \
  --query "properties.outputs.namespaceRootConnectionString.value" \
  --output tsv
```

## Troubleshooting

### Common Issues

1. **Namespace name conflicts**:
   - The template uses a fixed namespace name from the parameters file
   - Solution: Change the `serviceBusNamespaceName` value in `azuredeploy.parameters.json`
   
2. **Authentication errors**:
   - Solution: Run `az login` to authenticate with Azure
   
3. **Resource group already exists**:
   - The script is idempotent and will use the existing resource group

4. **Permission denied on script execution**:
   - Solution: Run `chmod +x deploy_template.sh` to make the script executable

### Getting Help

- [Azure Service Bus documentation](https://docs.microsoft.com/en-us/azure/service-bus-messaging/)
- [ARM template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.servicebus/namespaces)
- [Azure CLI reference](https://docs.microsoft.com/en-us/cli/azure/servicebus)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: This template uses Azure Service Bus API version `2024-01-01` for the latest features and capabilities.
