Set-Location $PSScriptRoot
$envFile = Join-Path $PSScriptRoot ".env"

Write-Host "Loading .env file..." -ForegroundColor Cyan
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+?)\s*=\s*(.+)$") {
            Set-Item -Path "Env:$($matches[1].Trim())" -Value $matches[2].Trim()
        }
    }
}

# ------------------------------
# HARD-CODED VALUES (EDIT HERE)
# ------------------------------

$tenantId          = $env:TENANT_ID
$subscriptionId    = $env:SUBSCRIPTION_ID
$resourceGroupName = "rg-dev-infra"

$apiAppName        = "api-app-$($env:SUFFIX)"
$clientAppName     = "client-app-$($env:SUFFIX)"

$readerGroupName   = "grp-test-reader-$($env:SUFFIX)"
$writerGroupName   = "grp-test-writer-$($env:SUFFIX)"

$readerUserUpn     = "reader1@$($env:DOMAIN_NAME)"
$writerUserUpn     = "writer1@$($env:DOMAIN_NAME)"

# ------------------------------
# AUTH
# ------------------------------

az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

Connect-MgGraph `
  -TenantId $tenantId `
  -Scopes `
    "Application.ReadWrite.All",
    "Group.ReadWrite.All",
    "User.ReadWrite.All" `
  -NoWelcome

# ------------------------------
# DELETE RESOURCE GROUP
# ------------------------------

Write-Host "Deleting Resource Group: $resourceGroupName" -ForegroundColor Red
az group delete `
  --name $resourceGroupName `
  --yes `
  --no-wait

# ------------------------------
# DELETE APP REGISTRATIONS
# ------------------------------

$apiApp = Get-MgApplication -Filter "displayName eq '$apiAppName'"
if ($apiApp) {
    Write-Host "Deleting API App: $apiAppName" -ForegroundColor Red
    Remove-MgApplication -ApplicationId $apiApp.Id -Confirm:$false
}

$clientApp = Get-MgApplication -Filter "displayName eq '$clientAppName'"
if ($clientApp) {
    Write-Host "Deleting Client App: $clientAppName" -ForegroundColor Red
    Remove-MgApplication -ApplicationId $clientApp.Id -Confirm:$false
}

# ------------------------------
# DELETE GROUPS
# ------------------------------

$readerGroup = Get-MgGroup -Filter "displayName eq '$readerGroupName'" -All | Select-Object -First 1
if ($readerGroup) {
    Write-Host "Deleting Group: $readerGroupName" -ForegroundColor Red
    Remove-MgGroup -GroupId $readerGroup.Id -Confirm:$false
}

$writerGroup = Get-MgGroup -Filter "displayName eq '$writerGroupName'" -All | Select-Object -First 1
if ($writerGroup) {
    Write-Host "Deleting Group: $writerGroupName" -ForegroundColor Red
    Remove-MgGroup -GroupId $writerGroup.Id -Confirm:$false
}

# ------------------------------
# DELETE USERS
# ------------------------------

$readerUser = Get-MgUser -UserId $readerUserUpn -ErrorAction SilentlyContinue
if ($readerUser) {
    Write-Host "Deleting User: $readerUserUpn" -ForegroundColor Red
    Remove-MgUser -UserId $readerUser.Id -Confirm:$false
}

$writerUser = Get-MgUser -UserId $writerUserUpn -ErrorAction SilentlyContinue
if ($writerUser) {
    Write-Host "Deleting User: $writerUserUpn" -ForegroundColor Red
    Remove-MgUser -UserId $writerUser.Id -Confirm:$false
}

Write-Host "Hard-coded cleanup completed." -ForegroundColor Green
