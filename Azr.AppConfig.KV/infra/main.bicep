@description('The name of the Key Vault to be created.')
param keyVaultName string

@description('The SKU of the Key Vault to be created.')
@allowed(['standard', 'premium'])
param keyVaultSku string = 'standard'

@description('The location for all resources.')
param location string = resourceGroup().location

@description('Specifies the name of the App Configuration store.')
param appConfigName string

@description('Specifies the SKU of the App Configuration store.')
param appConfigSku string = 'standard'

@description('AI provider configuration object containing OpenAI and Anthropic settings.')
param AI object

@secure()
@description('The OpenAI API key (passed securely from environment or pipeline).')
param openAIKey string = ''

@secure()
@description('The Anthropic API key (passed securely from environment or pipeline).')
param anthropicKey string = ''

module keyVaultModule 'modules/keyvault.bicep' = {
  name: 'deploy-keyvault'
  params: {
    keyVaultName: keyVaultName
    keyVaultSku: keyVaultSku
    location: location
    openAIKey: openAIKey
    anthropicKey: anthropicKey
  }
}

module appConfigModule 'modules/appconfig.bicep' = {
  name: 'deploy-appconfig'
  params: {
    appConfigName: appConfigName
    appConfigSku: appConfigSku
    location: location
    AI: AI
    keyVaultUri: keyVaultModule.outputs.keyVaultUri
  }
}

output keyVaultName string = keyVaultModule.outputs.keyVaultName
output keyVaultId string = keyVaultModule.outputs.keyVaultId
output keyVaultUri string = keyVaultModule.outputs.keyVaultUri
output appConfigName string = appConfigModule.outputs.appConfigName
