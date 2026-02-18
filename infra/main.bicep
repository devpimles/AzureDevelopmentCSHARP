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

@description('Name of the Azure Container Registry')
param acrName string = 'acr-dev'

@description('Application Insights name')
param appInsightsName string = 'appi-dev'

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

module acr './modules/acr.bicep' = {
  name: 'acr'
  params: {
    acrName: acrName
    location: location
  }
}

resource acrExisting 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource acrPullAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerAppName, acrExisting.id, 'acrpull')
  scope: acrExisting
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d' // AcrPull
    )
    principalId: containerAppApi.outputs.containerAppPrincipalId
  }
}

module appInsights './modules/appinsights.bicep' = {
  name: 'appInsights'
  params: {
    appInsightsName: appInsightsName
    location: location
    logAnalyticsWorkspaceId: logAnalytics.outputs.logAnalyticsId
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

@description('ACR resource ID')
output acrId string = acr.outputs.acrId

@description('ACR login server (e.g. myacr.azurecr.io)')
output acrLoginServer string = acr.outputs.acrLoginServer

@description('Application Insights connection string')
output appInsightsConnectionString string = appInsights.outputs.appInsightsConnectionString

@description('Application Insights instrumentation key')
output appInsightsInstrumentationKey string = appInsights.outputs.appInsightsInstrumentationKey
