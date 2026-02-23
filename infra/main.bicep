@description('Deployment location')
param location string = resourceGroup().location

@description('Shared Log Analytics workspace name')
param logAnalyticsWorkspaceName string = 'law-shared-dev'

@description('Application Insights name')
param appInsightsName string = 'appi-dev'

@description('Container App name')
param uamiApiName string = 'uami-api-dev'

@description('Name of the Azure Container Registry')
param acrName string = 'acr-dev'

@description('Container Apps environment name')
param containerAppsEnvironmentName string = 'aca-env-dev'

@description('Container App name')
param containerAppName string = 'api-dev'

@description('Container image')
param containerImage string = 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'

@description('Container revision')
param containerRevision string = '0-1-0'

@description('Cosmos DB account name')
param cosmosAccountName string = 'cosmoscalmstone-dev'

@description('Cosmos SQL database name')
param databaseName string = 'calmstone-dev'

module logAnalytics './modules/loganalytics.bicep' = {
  name: 'logAnalytics'
  params: {
    location: location
    workspaceName: logAnalyticsWorkspaceName
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

module uamiApi './modules/identity/uami-api.bicep' = {
  name: 'uamiApi'
  params: {
    uamiApiName: uamiApiName
    location: location
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
  name: guid(uamiApiName, acrExisting.id, 'acrpull')
  dependsOn: [
    acr
  ]
  scope: acrExisting
  properties: {
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      '7f951dda-4ed3-4680-a7ca-43fe172d538d'
    )
    principalId: uamiApi.outputs.uamiApiPrincipalId
    principalType: 'ServicePrincipal'
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
    dependsOn: [
    acrPullAssignment
  ]
  params: {
    appName: containerAppName
    location: location
    managedEnvironmentId: containerAppsEnv.outputs.environmentId
    image: containerImage
    uamiId: uamiApi.outputs.uamiApiId
    acrLoginServer: acr.outputs.acrLoginServer
    appInsightsConnectionString: appInsights.outputs.appInsightsConnectionString
    containerRevision: containerRevision
  }
}

module cosmosAccount './modules/cosmos-account.bicep' = {
  name: 'cosmosAccount'
  params: {
    location: location
    cosmosAccountName: cosmosAccountName
  }
}

module cosmosDatabaseOnboard './modules/cosmos-database-onboard.bicep' = {
  name: 'cosmosDatabaseOnboard'
  params: {
    cosmosAccountName: cosmosAccount.outputs.cosmosAccountName
    databaseName: databaseName
  }
}
