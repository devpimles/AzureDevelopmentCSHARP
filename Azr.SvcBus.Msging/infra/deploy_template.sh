#!/bin/bash
set -e

# Demo configuration
resourceGroupName="rg-demo"
location="westeurope"
templateFile="azuredeploy.json"
parametersFile="azuredeploy.parameters.json"

# Generate unique suffix for namespace
uniqueSuffix=$(date +"%H%M%S")
deploymentName="servicebus-demo-$uniqueSuffix"

# Create resource group (--output none to suppress output and make idempotent)
az group create --name "$resourceGroupName" --location "$location" --output none

# Deploy ARM template with runtime overrides
az deployment group create \
    --name "$deploymentName" \
    --resource-group "$resourceGroupName" \
    --template-file "$templateFile" \
    --parameters "@$parametersFile" \
    --output none

# Show connection string
connectionString=$(az deployment group show \
    --name "$deploymentName" \
    --resource-group "$resourceGroupName" \
    --query "properties.outputs.namespaceRootConnectionString.value" \
    --output tsv)

echo "Connection string: $connectionString"
