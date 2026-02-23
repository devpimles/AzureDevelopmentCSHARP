@description('Cosmos DB account name')
param cosmosAccountName string

@description('Cosmos SQL database name')
param databaseName string = 'calmstone-dev'

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' existing = {
  name: cosmosAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-05-15' = {
  parent: cosmosAccount
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource sqlContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-05-15' = {
  parent: sqlDatabase
  name: 'onboard'
  properties: {
    resource: {
      id: 'onboard'

      partitionKey: {
        paths: [
          '/tenantId'
        ]
        kind: 'Hash'
      }

      indexingPolicy: {
        indexingMode: 'consistent'
        automatic: true
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }

      defaultTtl: -1
    }
  }
}

output cosmosDatabaseName string = sqlDatabase.name
output cosmosContainerName string = sqlContainer.name
