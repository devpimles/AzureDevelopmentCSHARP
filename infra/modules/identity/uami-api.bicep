targetScope = 'resourceGroup'

@description('User-assigned managed identity for API runtime')
param uamiApiName string

@description('Location')
param location string

resource uamiApi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: uamiApiName
  location: location
}

output uamiApiId string = uamiApi.id
output uamiApiPrincipalId string = uamiApi.properties.principalId
output uamiApiClientId string = uamiApi.properties.clientId
