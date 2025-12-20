using './main.bicep'

// Programatically replace the placeholder _customerId_ with the customer identifier value before deployment.

param EnvironmentConfig = {
  appApi: {
    name: 'app-api-_customerId_'
    uniqueName: 'app-api-unique-_customerId_'
    roleReaderId: 'app-role-reader-_customerId_'
    roleWriterId: 'app-role-writer-_customerId_'
    scopeReadId: 'scope-test-read-_customerId_'
    scopeWriteId: 'scope-test-write-_customerId_'
    apiUri: 'api://localhost'
  }
  appclient: {
    name: 'app-api-_customerId_'
    uniqueName: 'app-api-unique-_customerId_'
    redirectUris: [
      'http://localhost'
    ]
    apiServicePrincipalId: ''
    apiScopeReadId: 'scope-test-read-_customerId_'
    apiScopeWriteId: 'scope-test-write-_customerId_'
  }
  groupReader: {
    displayName: 'group-reader-_customerId_'
    uniqueName: 'group-reader-unique-_customerId_'
    mailEnabled: false
    mailNickname: 'group-reader-nickname-_customerId_'
    securityEnabled: false
  }
  groupWriter: {
    displayName: 'group-writer-_customerId_'
    uniqueName: 'group-writer-unique-_customerId_'
    mailEnabled: false
    mailNickname: 'group-writer-nickname-_customerId_'
    securityEnabled: false
  }
}
