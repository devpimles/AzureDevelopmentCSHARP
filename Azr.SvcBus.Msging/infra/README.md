# Azure Service Bus Messaging Demo Infrastructure

This folder contains the infrastructure assets for the Service Bus demo. Unlike the other modules in this repository, this one currently uses ARM JSON templates and a shell deployment script.

## Overview

This template deploys the following Azure Service Bus resources:

- **Azure Service Bus namespace** (Standard tier)
- **File topic** for the file processing workflow
  - **Txt File Receiver** subscription with a filter for txt files
  - **Pdf File Receiver** subscription with a filter for pdf files
- **Chunk queue** for downstream processing

## Architecture

```text
File Sender -> File Topic -> Txt File Receiver (fileType = 'txt')
                      -> Pdf File Receiver (fileType = 'pdf')

Chunk Queue <- Chunk Receiver
```

## Workflow

1. `FileSender` publishes messages to the file topic.
2. The topic routes messages to subscriptions based on the `fileType` property.
3. Receivers process their matching messages.
4. Chunk messages continue through the queue-based stage.

## Files

```text
infra/
|-- azuredeploy.json
|-- azuredeploy.parameters.json
|-- deploy_template.sh
`-- README.md
```

## Prerequisites

- Azure CLI installed and configured
- An active Azure subscription
- Bash shell environment because the included deployment script is `deploy_template.sh`

## Quick Start

1. Ensure Azure CLI is installed:

```bash
az --version
```

2. Sign in:

```bash
az login
```

3. Run the deployment script from this folder:

```bash
./deploy_template.sh
```

## Template Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `serviceBusNamespaceName` | string | Name of the Service Bus namespace | `demo-servicebus-ns-20250826` |
| `fileTopicName` | string | Name of the file topic | `file-topic` |
| `chunkQueueName` | string | Name of the chunk queue | `chunk-queue` |
| `location` | string | Azure region for deployment | `westeurope` |

## Outputs

After a successful deployment, you will have:

- a Service Bus namespace
- a topic with filtered subscriptions
- a queue for the downstream stage
- a connection string for the namespace

## Troubleshooting

- Namespace names must be globally unique.
- If Azure CLI authentication fails, run `az login` again.
- If the resource group already exists, the deployment can still reuse it.

## References

- [Azure Service Bus documentation](https://learn.microsoft.com/en-us/azure/service-bus-messaging/)
- [ARM template reference for Service Bus namespaces](https://learn.microsoft.com/en-us/azure/templates/microsoft.servicebus/namespaces)
- [Azure CLI Service Bus reference](https://learn.microsoft.com/en-us/cli/azure/servicebus)
