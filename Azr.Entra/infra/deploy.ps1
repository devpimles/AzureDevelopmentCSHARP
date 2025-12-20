Set-Location $PSScriptRoot

. "$PSScriptRoot/scripts/Import-Env.ps1"
Import-Env

$customerId = $env:CUSTOMER_ID #--------- FACILITATE SEARCH OF RESOURCES FOR EACH SPECIFIC CUSTOMER
$environment = $env:ENVIRONMENT
$location = $env:LOCATION
$tenantId = $env:TENANT_ID
$subscriptionId = $env:SUBSCRIPTION_ID
$rg = "rg-$customerId-$environment"
$templateFile = "main.bicep"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName = "deploy-$customerId-$environment-$timestamp"

# DEPLOY

az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId
az group create --name $rg --location $location --output none
$deploymentResult = az deployment group create `
  --name $deploymentName `
  --resource-group $rg `
  --parameters customerId=$customerId environment=$environment `
  --template-file $templateFile `
  --query properties.outputs `
  --output json | ConvertFrom-Json

$readerGroupId = $deploymentResult.readerGroupId.value
$writerGroupId = $deploymentResult.writerGroupId.value

# NEW USERS

$domainName = $env:DOMAIN_NAME
$securePassword = ConvertTo-SecureString -String $env:INITIAL_NEW_USER_PASSWORD -AsPlainText -Force

$users = @(
    @{
        DisplayName = "Test Reader User"
        UPN         = "reader1@$domainName"
        Password    = $securePassword
        Group       = "Reader"
    },
    @{
        DisplayName = "Test Writer User"
        UPN         = "writer1@$domainName"
        Password    = $securePassword
        Group       = "Writer"
    }
)

Connect-MgGraph `
  -TenantId $tenantId `
  -Scopes "User.ReadWrite.All","GroupMember.ReadWrite.All"

. "$PSScriptRoot/scripts/New-EntraUser.ps1"

$createdUsers = @{}

foreach ($u in $users) {
    $existingUser = Get-MgUser -Filter "userPrincipalName eq '$($u.UPN)'" -ErrorAction SilentlyContinue

    if ($existingUser) {
        $createdUsers[$u.UPN] = $existingUser
        continue
    }

    $user = New-EntraUser `
        -DisplayName $u.DisplayName `
        -UserPrincipalName $u.UPN `
        -Password $u.Password

    $createdUsers[$u.UPN] = $user
}

# MEMBERSHIPS

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
        continue
    }

    New-MgGroupMember `
        -GroupId $targetGroupId `
        -DirectoryObjectId $userId
}

# INFO TO FILE

$data = @{
    customerId = $customerId
    resourceGroupName = $rg
    apiAppId = $ApiAppId
    clientAppId = $ClientAppId
    readerGroupId = $ReaderGroupId
    writerGroupId = $WriterGroupId
    readerUserId = $ReaderUserId
    writerUserId = $WriterUserId
}

$deployOutputsPath = "$PSScriptRoot/Deploy_Outputs.json"
$data | ConvertTo-Json -Depth 5 | Set-Content -Path $deployOutputsPath -Encoding UTF8