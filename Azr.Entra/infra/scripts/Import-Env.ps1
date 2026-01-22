function Import-Env  {
    param (
        [Parameter(Mandatory)]
        [string] $EnvFileName
    )

    $envPath = Join-Path $PSScriptRoot $EnvFileName

    if (-not (Test-Path $envPath)) {
        throw "Env file not found: $envPath"
    }

    Get-Content $envPath | ForEach-Object {
        if ($_ -match '^\s*#' -or $_ -match '^\s*$') {
            return
        }

        $name, $value = $_ -split '=', 2
        $name  = $name.Trim()
        $value = $value.Trim()

        [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}
