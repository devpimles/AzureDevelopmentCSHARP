@description('Deployment location')
param location string = resourceGroup().location

@description('Shared Log Analytics workspace name')
param logAnalyticsWorkspaceName string = 'law-shared-dev'

@description('Container Apps environment name')
param containerAppsEnvironmentName string = 'aca-env-dev'

@description('Container App name')
param containerAppName string = 'api-dev'

@description('Container image')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'


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

module containerAppApi './modules/containerapp-api.bicep' = {
  name: 'containerAppApi'
  params: {
    appName: containerAppName
    location: location
    managedEnvironmentId: containerAppsEnv.outputs.environmentId
    image: containerImage
  }
}

@description('Log Analytics resource ID')
output logAnalyticsId string = logAnalytics.outputs.logAnalyticsId

@description('Container Apps Environment ID')
output containerAppsEnvironmentId string = containerAppsEnv.outputs.environmentId

@description('Containner App Id')
output containerAppId string = containerAppApi.outputs.containerAppId

@description('Containner App PrincipalId')
output containerAppPrincipalId string = containerAppApi.outputs.containerAppPrincipalId
