@description('The suffix to append to the Log Analytics name.')
param suffix string

@description('Location of the Log Analytics resource')
param location string

@description('SKU of the Log Analytics resource')
param sku string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${suffix}'
  location: location
  properties: {
  publicNetworkAccessForIngestion: 'Enabled'
  publicNetworkAccessForQuery: 'Disabled'
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: sku
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output id string = logAnalytics.id
output name string = logAnalytics.name
output customerId string = logAnalytics.properties.customerId
