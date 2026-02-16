@description('Deployment location')
param location string = resourceGroup().location

@description('Shared Log Analytics workspace name')
param logAnalyticsWorkspaceName string = 'law-shared-dev'

@description('Container Apps environment name')
param containerAppsEnvironmentName string = 'aca-env-dev'

module logAnalytics './modules/loganalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    location: location
    workspaceName: logAnalyticsWorkspaceName
  }
}

module containerAppsEnv './modules/containerapps-env.bicep' = {
  name: 'containerAppsEnv'
  params: {
    location: location
    environmentName: containerAppsEnvironmentName
    logAnalyticsCustomerId: logAnalytics.outputs.workspaceCustomerId
    logAnalyticsSharedKey: logAnalytics.outputs.primarySharedKey
  }
}

@description('Container Apps Environment ID')
output containerAppsEnvironmentId string = containerAppsEnv.outputs.environmentId

@description('Log Analytics resource ID')
output logAnalyticsId string = logAnalytics.outputs.logAnalyticsId
