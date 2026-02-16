function Import-Env {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    # If relative path, resolve relative to this script's folder
    if (-not [System.IO.Path]::IsPathRooted($Path)) {
        $Path = Join-Path -Path $PSScriptRoot -ChildPath $Path
    }

    $envPath = (Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue)

    if (-not $envPath) {
        throw "Env file not found: $Path"
    }

    Get-Content -LiteralPath $envPath.Path | ForEach-Object {
        $line = $_.Trim()

        if ([string]::IsNullOrWhiteSpace($line)) { return }
        if ($line.StartsWith("#")) { return }

        $parts = $line -split "=", 2
        if ($parts.Count -ne 2) { return }

        $key = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"')

        [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
    }
}
