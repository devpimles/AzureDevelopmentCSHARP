@description('Cosmos DB account name')
param cosmosAccountName string

@description('Location')
param location string

@description('Consistency level for Cosmos DB')
@allowed([
  'Strong'
  'BoundedStaleness'
  'Session'
  'ConsistentPrefix'
  'Eventual'
])
param consistencyLevel string = 'Session'

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: cosmosAccountName
  location: location
  kind: 'GlobalDocumentDB'

  properties: {
    databaseAccountOfferType: 'Standard'

    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]

    consistencyPolicy: {
      defaultConsistencyLevel: consistencyLevel
      // NOTE: maxIntervalInSeconds and maxStalenessPrefix are required only for BoundedStaleness
    }

    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]

    minimalTlsVersion: 'Tls12'
    publicNetworkAccess: 'Enabled'

    networkAclBypass: 'None'
    networkAclBypassResourceIds: []

    ipRules: []
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []

    enableAutomaticFailover: false
    enableMultipleWriteLocations: false

    enableFreeTier: false

    disableLocalAuth: false

    disableKeyBasedMetadataWriteAccess: false
  }
}

output cosmosAccountName string = cosmosAccount.name
output cosmosEndpoint string = cosmosAccount.properties.documentEndpoint
output cosmosResourceId string = cosmosAccount.id
