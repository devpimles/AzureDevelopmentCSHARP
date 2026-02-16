targetScope = 'resourceGroup'

@description('Name of the Log Analytics workspace')
param workspaceName string

@description('Location of the Log Analytics workspace')
param location string

@description('SKU of the Log Analytics workspace')
param sku string = 'PerGB2018'

@description('Log retention in days')
param retentionInDays int = 30

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: retentionInDays
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    sku: {
      name: sku
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

@description('Log Analytics resource ID')
output logAnalyticsId string = logAnalytics.id

@description('Log Analytics customer ID (workspace ID)')
output workspaceCustomerId string = logAnalytics.properties.customerId

@secure()
@description('Log Analytics primary shared key')
output primarySharedKey string = logAnalytics.listKeys().primarySharedKey
