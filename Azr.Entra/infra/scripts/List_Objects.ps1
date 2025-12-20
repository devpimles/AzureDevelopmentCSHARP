$scriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Get-Location }
$envFile = Join-Path $scriptRoot ".env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+?)\s*=\s*(.+)$") {
            Set-Item -Path "Env:$($matches[1].Trim())" -Value $matches[2].Trim()
        }
    }
}

$tenantId = $env:TENANT_ID
Write-Host "Tenant: $tenantId" -ForegroundColor Yellow

Connect-MgGraph `
    -TenantId $tenantId `
    -Scopes "Directory.Read.All" `
    -NoWelcome

$ctx = Get-MgContext
Write-Host "Authenticated account : $($ctx.Account)" -ForegroundColor Green
Write-Host "Tenant ID            : $($ctx.TenantId)" -ForegroundColor Green
Write-Host "Auth type            : $($ctx.AuthType)" -ForegroundColor Green

$sps = Get-MgServicePrincipal -All

Write-Host "`n Application Service Principals " -ForegroundColor Cyan

$sps |
    Where-Object {
        $_.ServicePrincipalType -eq "Application" -and
        -not ($_.Tags -contains "WindowsAzureActiveDirectoryIntegratedApp")
    } |
    Sort-Object DisplayName |
    Select-Object DisplayName, AppId, Id |
    Out-Host

Write-Host "`n Managed Identities" -ForegroundColor Cyan

$sps |
    Where-Object {
        $_.ServicePrincipalType -eq "ManagedIdentity"
    } |
    Sort-Object DisplayName |
    Select-Object DisplayName, AppId, Id |
    Out-Host

Write-Host "`n Other Service Principals" -ForegroundColor Cyan

$sps |
    Where-Object {
        $_.ServicePrincipalType -notin @("Application", "ManagedIdentity")
    } |
    Sort-Object DisplayName |
    Select-Object DisplayName, AppId, Id, ServicePrincipalType |
    Out-Host

Write-Host "`n Users (Tenant)" -ForegroundColor Cyan

Get-MgUser -All |
    Sort-Object DisplayName |
    Select-Object DisplayName, UserPrincipalName, UserType |
    Out-Host

Write-Host "`n Groups" -ForegroundColor Cyan

Get-MgGroup -All |
    Sort-Object DisplayName |
    Select-Object `
        DisplayName,
        Id,
        SecurityEnabled,
        MailEnabled,
        GroupTypes |
    Out-Host
