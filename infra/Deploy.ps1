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
$containerAppsEnvironmentName = "aca-env-$environment"
$containerAppName = "api-$environment"
$containerImage = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
$acrName = "acrcalmstone$environment"

# -------- Azure Login --------
az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

# -------- Resource Group --------
az group create `
  --name $rg `
  --location $location `
  --output none

# -------- Deployment --------
az deployment group create `
  --name $deploymentName `
  --resource-group $rg `
  --template-file $templateFile `
  --parameters `
      location=$location `
      logAnalyticsWorkspaceName=$logAnalyticsWorkspaceName `
      containerAppsEnvironmentName=$containerAppsEnvironmentName `
      containerAppName=$containerAppName `
      containerImage=$containerImage `
      acrName=$acrName `
  --output none
