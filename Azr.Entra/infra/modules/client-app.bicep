extension microsoftGraphV1

@description('The name of the client app')
param name string

@description('API Application (client) ID')
param apiApplicationId string

@description('Scope ID for test.read')
param scopeReadId string

@description('Scope ID for test.write')
param scopeWriteId string

resource clientApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: name
  uniqueName: '${name}-${tenant().tenantId}'
  isFallbackPublicClient: true

  publicClient: {
    redirectUris: [
      'http://localhost'
    ]
  }

  requiredResourceAccess: [
    {
      resourceAppId: apiApplicationId
      resourceAccess: [
        {
          id: scopeReadId
          type: 'Scope'
        }
        {
          id: scopeWriteId
          type: 'Scope'
        }
      ]
    }
  ]

  web: null
  spa: null
}

resource clientSp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: clientApp.appId
}

output clientAppName string = name
output clientApplicationId string = clientApp.appId
output clientServicePrincipalId string = clientSp.id
