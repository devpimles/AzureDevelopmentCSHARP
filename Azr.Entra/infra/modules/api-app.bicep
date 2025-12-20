extension microsoftGraphV1

param name string
param uniqueName string
param roleReaderId string
param roleWriterId string
param scopeReadId string
param scopeWriteId string
param apiUri string

resource apiApp 'Microsoft.Graph/applications@v1.0' = {
  displayName: name
  uniqueName: uniqueName

  identifierUris: [
    apiUri
  ]

  api: {
    requestedAccessTokenVersion: 2

    oauth2PermissionScopes: [
      {
        id: scopeReadId
        value: 'test.read'
        type: 'User'
        isEnabled: true
        adminConsentDisplayName: 'Read test data'
        adminConsentDescription: 'Allows reading test data'
        userConsentDisplayName: 'Read test data'
        userConsentDescription: 'Read test data'
      }
      {
        id: scopeWriteId
        value: 'test.write'
        type: 'User'
        isEnabled: true
        adminConsentDisplayName: 'Write test data'
        adminConsentDescription: 'Allows writing test data'
        userConsentDisplayName: 'Write test data'
        userConsentDescription: 'Write test data'
      }
    ]
  }

  appRoles: [
    {
      id: roleReaderId
      value: 'Test.Reader'
      displayName: 'Test Reader'
      description: 'Can read test data'
      isEnabled: true
      allowedMemberTypes: [ 'User', 'Application' ]
    }
    {
      id: roleWriterId
      value: 'Test.Writer'
      displayName: 'Test Writer'
      description: 'Can write test data'
      isEnabled: true
      allowedMemberTypes: [ 'User', 'Application' ]
    }
  ]

  isFallbackPublicClient: true
  publicClient: {
    redirectUris: [
      'http://localhost'
    ]
  }
  web: null
  spa: null
}

resource apiAppSp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: apiApp.appId
}

output apiApplicationId string = apiApp.appId
output apiServicePrincipalId string = apiAppSp.id
output roleReaderId string = roleReaderId
output roleWriterId string = roleWriterId
