using './main.bicep'
param customerId = 'abc123'
param EnvironmentConfig = {
  appApi: {
    name: 'app-api'
    apiUri: 'api://localhost'
  }
  appClient: {
    name: 'app-api'
    redirectUris: [
      'http://localhost'
    ]
    apiServicePrincipalId: ''
  }
  groupReader: {
    name: 'group-reader'
  }
  groupWriter: {
    name: 'group-writer'
  }
}
