#!/bin/bash
set -e

# az account show --query "{user: user.name, tenant: tenantId, subscription: id}" -o table

subscriptionId="d1e9da6e-7000-4e27-a5f8-5b1c5de243cc"
az account set --subscription "$subscriptionId"
userId=$(az ad signed-in-user show --query id -o tsv)

# Demo configuration
resourceGroupName="rg-demo"
location="westeurope"
templateFile="azuredeploy.json"

# Generate unique suffix for namespace
uniqueSuffix=$(date +"%H%M%S")
deploymentName="keyvault-appconfig-demo-$uniqueSuffix"

# Create resource group (--output none to suppress output and make idempotent)
az group create --name "$resourceGroupName" --location "$location" --output none

# Deploy ARM template with parameters file
echo "Starting deployment: $deploymentName"
az deployment group create \
    --name "$deploymentName" \
    --resource-group "$resourceGroupName" \
    --template-file "$templateFile" \
    --parameters @azuredeploy.parameters.json

# List all deleted, but not yet purged App Configuration stores.
# az appconfig list-deleted
# Permanently delete an App Configuration store. 
# az appconfig purge --name demo-app-config-20250910
