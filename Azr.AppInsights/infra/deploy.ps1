Set-Location $PSScriptRoot
$envFile = Join-Path $PSScriptRoot ".env"

Write-Host "Loading .env file..." -ForegroundColor Cyan
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+?)\s*=\s*(.+)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()

            Set-Item -Path "Env:$name" -Value $value
        }
    }
}
Write-Host "Subscription: $env:SUBSCRIPTION_ID" -ForegroundColor Yellow
Write-Host "Tenant: $env:TENANT_ID" -ForegroundColor Yellow

$env                = "dev"
$tenantId           = $env:TENANT_ID
$subscriptionId     = $env:SUBSCRIPTION_ID
$resourceGroupName  = "rg-$env-infra"
$location           = "NorthEurope"
$templateFile       = "main.bicep"
$parametersFile     = "main.$env.bicepparam"
$timestamp          = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName     = "proj-$env-$timestamp"

az login --tenant $tenantId
az account set --subscription $subscriptionId

Write-Host "DEPLOY RESOURCE GROUP" -ForegroundColor Yellow
az group create --name $resourceGroupName --location $location --output none

Write-Host "DEPLOY RESOURCES" -ForegroundColor Yellow
$deploymentGroup = az deployment group create `
  --name $deploymentName `
  --resource-group $resourceGroupName `
  --template-file $templateFile `
  --parameters $parametersFile #`
  #--what-if

Write-Host "AI Connection String: $($deploymentGroup.properties.outputs.aiConnectionString.value)" -ForegroundColor Yellow