Set-Location $PSScriptRoot

. "$PSScriptRoot/scripts/Import-Env.ps1"
Import-Env ".env"

$customerId = $env:CUSTOMER_ID 
$environment = $env:ENVIRONMENT
$location = $env:LOCATION
$tenantId = $env:TENANT_ID
$subscriptionId = $env:SUBSCRIPTION_ID
$rg = "rg-$customerId-$environment"
$templateFile = "main.bicep"
$parametersFile = "main.dev.bicepparam"
$timeStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$deploymentName = "deploy-$customerId-$environment-$timeStamp"

# DEPLOY

az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId
az group create --name $rg --location $location --output none

az deployment group create `
  --name $deploymentName `
  --resource-group $rg `
  --parameters $parametersFile `
  --template-file $templateFile `
  --output none

$deploymentShow = az deployment group show `
  --resource-group $rg `
  --name $deploymentName `
  --query properties.outputs `
  --output json | ConvertFrom-Json

$readerGroupId = $deploymentShow.readerGroupId.value
$writerGroupId = $deploymentShow.writerGroupId.value

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
    deploymentName = $deploymentName
    customerId = $customerId
    resourceGroupName = $rg
    apiAppId = $deploymentShow.apiAppApplicationId.value
    clientAppId = $deploymentShow.clientAppApplicationId.value
    readerGroupId = $ReaderGroupId
    writerGroupId = $WriterGroupId
    readerUserId = $createdUsers["reader1@$domainName"].Id
    writerUserId = $createdUsers["writer1@$domainName"].Id
    readerGroupMailNickName = $deploymentShow.readerGroupMailNickName.value
    writerGroupMailNickName = $deploymentShow.writerGroupMailNickName.value
}

$deployOutputsPath = "$PSScriptRoot/Deploy_Outputs.json"
$data | ConvertTo-Json -Depth 5 | Set-Content -Path $deployOutputsPath -Encoding UTF8