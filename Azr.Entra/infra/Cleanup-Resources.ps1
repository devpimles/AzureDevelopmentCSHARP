Set-Location $PSScriptRoot

$deployOutputs = Get-Content "$PSScriptRoot/Deploy_Outputs.json" | ConvertFrom-Json

. "$PSScriptRoot/scripts/Import-Env.ps1"
Import-Env "../.env"

$environment = $env:ENVIRONMENT
$tenantId = $env:TENANT_ID
$subscriptionId = $env:SUBSCRIPTION_ID

# Rg

az login --tenant $tenantId | Out-Null
az account set --subscription $subscriptionId

az group delete --name $deployOutputs.resourceGroupName --yes --no-wait

# Entra

Connect-MgGraph `
  -TenantId $tenantId `
  -Scopes `
    "Application.ReadWrite.All",
    "Group.ReadWrite.All",
    "User.ReadWrite.All" `
  -NoWelcome

Remove-MgApplication -ApplicationId $deployOutputs.apiAppId -Confirm:$false
Remove-MgApplication -ApplicationId $deployOutputs.clientAppId -Confirm:$false
Remove-MgGroup -GroupId $deployOutputs.readerGroupId -Confirm:$false
Remove-MgGroup -GroupId $deployOutputs.writerGroupId -Confirm:$false
Remove-MgUser -UserId $deployOutputs.readerUserId -Confirm:$false
Remove-MgUser -UserId $deployOutputs.writerUserId -Confirm:$false