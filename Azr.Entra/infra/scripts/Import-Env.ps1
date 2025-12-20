function Import-Env {
    param (
        [string]$Path = (Join-Path $PSScriptRoot "..\.env")
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "Env file not found: $Path"
        return
    }

    Get-Content $Path | ForEach-Object {
        if ($_ -match "^\s*([^#=]+?)\s*=\s*(.+)$") {
            $name  = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Item -Path "Env:$name" -Value $value
        }
    }
}
