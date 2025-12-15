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

Write-Host "Subscription: $env:SUBSCRIPTION_ID" -ForegroundColor Yellow
Write-Host "Tenant      : $env:TENANT_ID" -ForegroundColor Yellow

$environment        = "dev"
$tenantId           = $env:TENANT_ID
$subscriptionId     = $env:SUBSCRIPTION_ID
$resourceGroupName  = "rg-$environment-infra"
$location           = "NorthEurope"
$templateFile       = "main.bicep"
$timestamp          = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName     = "proj-$environment-$timestamp"

# ---------- Azure CLI ----------
az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

# ---------- Resource Group (idempotent) ----------
Write-Host "Ensuring resource group exists..." -ForegroundColor Yellow
az group create `
  --name $resourceGroupName `
  --location $location `
  --output none

# ---------- Deploy Infrastructure ----------
Write-Host "Deploying infrastructure..." -ForegroundColor Yellow

$deploymentResult = az deployment group create `
  --name $deploymentName `
  --resource-group $resourceGroupName `
  --template-file $templateFile `
  --query properties.outputs `
  --output json | ConvertFrom-Json

$readerGroupId = $deploymentResult.readerGroupId.value
$writerGroupId = $deploymentResult.writerGroupId.value

Write-Host "Reader Group Id : $readerGroupId" -ForegroundColor Cyan
Write-Host "Writer Group Id : $writerGroupId" -ForegroundColor Cyan

# ---------- Microsoft Graph ----------
Connect-MgGraph `
  -TenantId $tenantId `
  -Scopes "User.ReadWrite.All","GroupMember.ReadWrite.All"

# ---------- Users definition ----------
$domainName = $env:DOMAIN_NAME
$users = @(
    @{
        DisplayName = "Test Reader User"
        UPN         = "reader1@$domainName"
        Password    = "P@ssw0rd!123"
        Group       = "Reader"
    },
    @{
        DisplayName = "Test Writer User"
        UPN         = "writer1@$domainName"
        Password    = "P@ssw0rd!123"
        Group       = "Writer"
    }
)

. "$PSScriptRoot/scripts/create_user.ps1"

$createdUsers = @{}

# ---------- Create users (idempotent) ----------
foreach ($u in $users) {
    $existingUser = Get-MgUser -Filter "userPrincipalName eq '$($u.UPN)'" -ErrorAction SilentlyContinue

    if ($existingUser) {
        Write-Host "User already exists: $($u.UPN)" -ForegroundColor Yellow
        $createdUsers[$u.UPN] = $existingUser
        continue
    }

    Write-Host "Creating user: $($u.UPN)" -ForegroundColor Cyan

    $user = Create-EntraUser `
        -DisplayName $u.DisplayName `
        -UserPrincipalName $u.UPN `
        -Password $u.Password

    $createdUsers[$u.UPN] = $user
}

# ---------- Assign group membership (idempotent) ----------
foreach ($u in $users) {
    $userId = $createdUsers[$u.UPN].Id

    $targetGroupId = switch ($u.Group) {
        "Reader" { $readerGroupId }
        "Writer" { $writerGroupId }
    }

    $alreadyMember = Get-MgGroupMember `
        -GroupId $targetGroupId `
        -All `
        | Where-Object { $_.Id -eq $userId }

    if ($alreadyMember) {
        Write-Host "User $($u.UPN) already in $($u.Group) group" -ForegroundColor Yellow
        continue
    }

    New-MgGroupMember `
        -GroupId $targetGroupId `
        -DirectoryObjectId $userId

    Write-Host "Added $($u.UPN) to $($u.Group) group" -ForegroundColor Green
}

Write-Host "Deployment completed successfully." -ForegroundColor Green