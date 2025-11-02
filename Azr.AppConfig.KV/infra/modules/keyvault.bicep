@description('The name of the Key Vault to be created.')
param keyVaultName string

@description('The SKU of the Key Vault to be created.')
@allowed(['standard', 'premium'])
param keyVaultSku string = 'standard'

@description('The location for the Key Vault.')
param location string

@secure()
param openAIKey string

@secure()
param anthropicKey string

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: false
    softDeleteRetentionInDays: 7
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    tenantId: subscription().tenantId
    sku: {
      name: keyVaultSku
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// ------------------------------------------------------
// Secrets (AI API Keys)
// ------------------------------------------------------
resource openAISecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'AI--OpenAI--ApiKey'
  properties: {
    value: openAIKey
  }
}

resource anthropicSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'AI--Anthropic--ApiKey'
  properties: {
    value: anthropicKey
  }
}

output keyVaultName string = keyVaultName
output keyVaultId string = keyVault.id
output keyVaultUri string = keyVault.properties.vaultUri
