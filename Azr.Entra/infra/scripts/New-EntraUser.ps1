function New-EntraUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $DisplayName,

        [Parameter(Mandatory)]
        [string] $UserPrincipalName,

        [Parameter(Mandatory)]
        [SecureString] $Password,

        [Parameter()]
        [bool] $ForceChangePasswordNextSignIn = $false
    )

    Write-Host "Creating Entra user: $UserPrincipalName" -ForegroundColor Cyan

    $mailNickname = ($UserPrincipalName -split '@')[0]

    $passwordProfile = @{
        Password = $Password
        ForceChangePasswordNextSignIn = $ForceChangePasswordNextSignIn
    }

    try {
        $user = New-MgUser `
            -AccountEnabled:$true `
            -DisplayName $DisplayName `
            -MailNickname $mailNickname `
            -UserPrincipalName $UserPrincipalName `
            -UserType "Member" `
            -PasswordProfile $passwordProfile

        Write-Host "User created successfully." -ForegroundColor Green
        Write-Host "UPN     : $($user.UserPrincipalName)" -ForegroundColor Green
        Write-Host "ObjectId: $($user.Id)" -ForegroundColor Green

        return $user
    }
    catch {
        Write-Host "Failed to create user: $UserPrincipalName" -ForegroundColor Red
        throw
    }
}
