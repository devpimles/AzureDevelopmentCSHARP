targetScope = 'resourceGroup'

@description('Name of the Container App')
param appName string

@description('Location for the Container App')
param location string

@description('Managed Environment resource ID')
param managedEnvironmentId string

@description('Container image to deploy')
param image string

@description('User-assigned managed identity resource ID')
param uamiId string

@description('ACR login server, e.g. acrcalmstonedev.azurecr.io')
param acrLoginServer string

@description('Container port')
param targetPort int = 8080

@secure()
@description('Application Insights connection string')
param appInsightsConnectionString string

@description('Container revision')
param containerRevision string = '0-1-0'

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: appName
  location: location

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uamiId}': {}
    }
  }

  properties: {
    managedEnvironmentId: managedEnvironmentId

    configuration: {
      activeRevisionsMode: 'Single'
      registries: [
        {
          server: acrLoginServer
          identity: uamiId
        }
      ]
      secrets: [
        {
          name: 'appinsights-conn'
          value: appInsightsConnectionString
        }
      ]
      ingress: {
        external: false
        targetPort: targetPort
        allowInsecure: false
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
    }

    template: {
      revisionSuffix: containerRevision
      containers: [
        {
          name: appName
          image: image
          env: [
            { name: 'ASPNETCORE_URLS', value: 'http://+:8080' }
            { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', secretRef: 'appinsights-conn' }
          ]
          resources: {
            cpu: any('0.25')
            memory: '0.5Gi'
          }
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

@description('Container App Id')
output containerAppId string = containerApp.id

