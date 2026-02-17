targetScope = 'resourceGroup'

@description('Name of the Azure Container Registry')
param acrName string

@description('Deployment location')
param location string

@description('ACR SKU')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Standard'

@description('Enable admin user (should be false when using Managed Identity)')
param adminUserEnabled bool = false

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Enabled'
  }
}

@description('ACR resource ID')
output acrId string = acr.id

@description('ACR login server (e.g. myacr.azurecr.io)')
output acrLoginServer string = acr.properties.loginServer
