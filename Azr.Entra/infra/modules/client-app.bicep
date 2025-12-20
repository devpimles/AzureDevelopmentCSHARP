extension microsoftGraphV1


param name string
param uniqueName string
param redirectUris array 
param apiServicePrincipalId string
param apiScopeReadId string
param apiScopeWriteId string

resource clientApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: name
  uniqueName: uniqueName
  isFallbackPublicClient: true

  publicClient: {
    redirectUris: redirectUris
  }

  requiredResourceAccess: [
    {
      resourceAppId: apiServicePrincipalId
      resourceAccess: [
        {
          id: apiScopeReadId
          type: 'Scope'
        }
        {
          id: apiScopeWriteId
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

output clientApplicationId string = clientApp.appId
output clientServicePrincipalId string = clientSp.id
