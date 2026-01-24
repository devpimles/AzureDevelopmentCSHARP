extension microsoftGraphV1

param name string
param redirectUris array 
param apiServicePrincipalId string
param scopeReadId string
param scopeWriteId string

param customerId string

resource clientApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: '${name}-${customerId}'
  uniqueName: '${name}-${customerId}-${uniqueString(customerId)}'
  isFallbackPublicClient: true

  publicClient: {
    redirectUris: redirectUris
  }

  requiredResourceAccess: [
    {
      resourceAppId: apiServicePrincipalId
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

resource clientAppSp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: clientApp.appId
}

output clientAppClientId string = clientApp.appId
output clientAppObjectId string = clientApp.id
output clientAppSPId string = clientAppSp.id
