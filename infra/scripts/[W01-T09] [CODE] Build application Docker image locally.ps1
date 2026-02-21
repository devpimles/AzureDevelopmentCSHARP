Set-Location $PSScriptRoot

. "$PSScriptRoot/Import-Env.ps1"
Import-Env "../.env"

Set-Location "../../src/api/"

docker build -t api:0.1.0 .

docker run -p 8080:8080 -e APPLICATIONINSIGHTS_CONNECTION_STRING="$env:APPLICATIONINSIGHTS_CONNECTION_STRING" api:0.1.0