function Create-EntraServicePrincipal {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $SubscriptionId,

        [Parameter(Mandatory)]
        [string] $ResourceGroupName,

        [Parameter()]
        [string] $Role = "Managed Identity Contributor"
    )

    Write-Host "Creating Service Principal: $Name" -ForegroundColor Cyan

    $scope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"

    try {
        $sp = az ad sp create-for-rbac `
            --name $Name `
            --role $Role `
            --scopes $scope `
            --output json | ConvertFrom-Json

        Write-Host "Service Principal created successfully." -ForegroundColor Green
        Write-Host "DisplayName : $($sp.displayName)" -ForegroundColor Green
        Write-Host "AppId       : $($sp.appId)" -ForegroundColor Green
        Write-Host "TenantId    : $($sp.tenant)" -ForegroundColor Green

        return [PSCustomObject]@{
            DisplayName = $sp.displayName
            AppId       = $sp.appId
            Password    = $sp.password
            TenantId    = $sp.tenant
            Scope       = $scope
            Role        = $Role
        }
    }
    catch {
        Write-Host "Failed to create Service Principal: $Name" -ForegroundColor Red
        throw
    }
}
