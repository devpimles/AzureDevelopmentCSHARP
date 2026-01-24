Set-Location $PSScriptRoot

. "$PSScriptRoot/scripts/Import-Env.ps1"
Import-Env "../.env"

$tenantId = $env:TENANT_ID
$domainName = $env:DOMAIN_NAME
$securePassword = ConvertTo-SecureString -String $env:INITIAL_NEW_USER_PASSWORD -AsPlainText -Force
Write-Host "Secure password $($securePassword)." -ForegroundColor Yellow

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

foreach ($u in $users) {

    $existingUser = Get-MgUser `
        -Filter "userPrincipalName eq '$($u.UPN)'" `
        -Property Id,UserPrincipalName,AccountEnabled,PasswordPolicies `
        -ConsistencyLevel eventual

    if ($null -ne $existingUser) {

        $userId = $existingUser.Id

        Write-Host "User exists: $($u.UPN)" -ForegroundColor Green
        Write-Host "  Enabled: $($existingUser.AccountEnabled)"
        Write-Host "  PasswordPolicies: $($existingUser.PasswordPolicies)"

        Write-Host "  Authentication methods:"
        Get-MgUserAuthenticationMethod -UserId $userId |
            Select-Object Id,AdditionalProperties

        continue
    }

    Write-Host "User $($u.UPN) does not exist." -ForegroundColor Yellow
}