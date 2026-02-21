Set-Location $PSScriptRoot

. "$PSScriptRoot/Import-Env.ps1"
Import-Env "../.env"

Set-Location "../../src/api/"

$environment = "dev"
$rg = "rg-azdev-$environment"
$acrName = "acrcalmstone$environment"
$acrLoginServer = az acr show --name $acrName --resource-group $rg --query loginServer --output tsv 

$imageName = "api"
$imageTag  = "0.1.0"

docker login $acrLoginServer `
  --username $env:ACR_USERNAME `
  --password $env:ACR_PASSWORD

docker tag "${imageName}:${imageTag}" "${acrLoginServer}/${imageName}:${imageTag}"
docker push "${acrLoginServer}/${imageName}:${imageTag}"