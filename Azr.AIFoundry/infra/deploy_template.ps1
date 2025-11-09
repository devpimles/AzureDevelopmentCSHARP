$ErrorActionPreference = "Stop"

$subscriptionId   = $env:SUBSCRIPTION_ID
$resourceGroupName = "rg-demo"
$location          = "westeurope"
$templateFile      = "main.bicep"
$parametersFile    = "main.dev.bicepparam"
$timestamp         = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName    = "aifoundry-$timestamp"

az account set --subscription $subscriptionId

az group create --name $resourceGroupName --location $location --output none

$deployment = az deployment group create `
  --name $deploymentName `
  --resource-group $resourceGroupName `
  --template-file $templateFile `
  --parameters $parametersFile `
  --output json | ConvertFrom-Json 

$aiFoundryName = $deployment.properties.outputs.aiFoundryName.value
$aiProjectName = $deployment.properties.outputs.aiProjectName.value

az resource list --resource-group $resourceGroupName --output table

az cognitiveservices account keys list `
  --name $aiFoundryName `
  --resource-group $resourceGroupName `
  --output table

az cognitiveservices account show `
  --name $aiFoundryName `
  --resource-group $resourceGroupName `
  --query "properties.endpoint" -o tsv 
