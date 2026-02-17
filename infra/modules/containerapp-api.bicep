targetScope = 'resourceGroup'

@description('Name of the Container App')
param appName string

@description('Location for the Container App')
param location string

@description('Managed Environment resource ID')
param managedEnvironmentId string

@description('Container image to deploy')
param image string

@description('Container port')
param targetPort int = 80

/* 
RevisionSuffix is “deploy new revision trigger” during infra iteration 
This is: 
- Valid for learning 
- Valid for debugging 
- Not required in production (CI/CD handles this) 
*/

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: appName
  location: location

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    managedEnvironmentId: managedEnvironmentId

    configuration: {
      activeRevisionsMode: 'Single'
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
      revisionSuffix: 'v4'
      containers: [
        {
          name: appName
          image: image
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

@description('Containner App Id')
output containerAppId string = containerApp.id

@description('Containner App PrincipalId')
output containerAppPrincipalId string = containerApp.identity.principalId
