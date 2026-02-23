Set-Location $PSScriptRoot

# Load environment variables
. "$PSScriptRoot/scripts/Import-Env.ps1"
Import-Env "../.env"

# -------- Context --------
$tenantId       = $env:TENANT_ID
$subscriptionId = $env:SUBSCRIPTION_ID

# Deployment environment
$environment = "dev"

# Location & Resource Group
$location = "northeurope"
$rg        = "rg-azdev-$environment"

# Template
$templateFile = "$PSScriptRoot/main.bicep"

# Naming
$timeStamp      = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName = "deploy-$environment-$timeStamp"

# Parameters
$logAnalyticsWorkspaceName = "law-shared-$environment"
$appInsightsName = "appi-$environment"
$uamiApiName = "uami-api-$environment"
$acrName = "acrcalmstone$environment"
$containerAppsEnvironmentName = "aca-env-$environment"
$containerAppName = "api-$environment"
$containerImage = "acrcalmstonedev.azurecr.io/api:0.1.0"
$containerRevision = "0-1-0-ai"
$cosmosAccountName = "cosmoscalmstone-$environment"
$databaseName = "calmstone-$environment"

# -------- Azure Login --------
az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

# -------- Resource Group --------
az group create `
  --name $rg `
  --location $location `
  --output none

# -------- Platform CD --------
az deployment group create `
  --name $deploymentName `
  --resource-group $rg `
  --template-file $templateFile `
  --parameters `
      location=$location `
      logAnalyticsWorkspaceName=$logAnalyticsWorkspaceName `
      appInsightsName=$appInsightsName `
      uamiApiName=$uamiApiName `
      acrName=$acrName `
      containerAppsEnvironmentName=$containerAppsEnvironmentName `
      containerAppName=$containerAppName `
      containerImage=$containerImage `
      containerRevision=$containerRevision `
      cosmosAccountName=$cosmosAccountName `
      databaseName=$databaseName `
  --output none
