targetScope = 'resourceGroup'

@description('Location for the Container Apps environment')
param location string

@description('Name of the Container Apps environment')
param environmentName string

@description('Log Analytics workspace customer ID')
param logAnalyticsCustomerId string

@secure()
@description('Log Analytics workspace shared key')
param logAnalyticsSharedKey string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: environmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsCustomerId
        sharedKey: logAnalyticsSharedKey
      }
    }
  }
}

@description('Containner App Environment Id')
output environmentId string = managedEnvironment.id
