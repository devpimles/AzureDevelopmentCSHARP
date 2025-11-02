@description('Specifies the name of the App Configuration store.')
param appConfigName string

@description('Specifies the SKU of the App Configuration store.')
param appConfigSku string = 'standard'

@description('The location for the App Configuration store.')
param location string

@description('AI provider configuration object containing OpenAI and Anthropic settings.')
param AI object

@description('The Key Vault URI used for Key Vault references.')
param keyVaultUri string

var aiOpenAIKeys = [
  'ModelName'
  'Temperature'
  'MaxTokens'
  'TopP'
  'FrequencyPenalty'
  'PresencePenalty'
]

var aiAnthropicKeys = [
  'ModelName'
  'Temperature'
  'MaxTokens'
  'TopK'
  'TopP'
]

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2024-05-01' = {
  name: appConfigName
  location: location
  sku: {
    name: appConfigSku
  }
  properties: {}
}

@batchSize(1)
resource openAIKeys 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = [
  for key in aiOpenAIKeys: {
    parent: appConfig
    name: 'AI:OpenAI:${key}'
    properties: {
      value: string(AI.OpenAI[key])
      contentType: 'text/plain'
      tags: {
        provider: 'OpenAI'
        category: 'AIConfig'
      }
    }
  }
]

@batchSize(1)
resource anthropicKeys 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = [
  for key in aiAnthropicKeys: {
    parent: appConfig
    name: 'AI:Anthropic:${key}'
    properties: {
      value: string(AI.Anthropic[key])
      contentType: 'text/plain'
      tags: {
        provider: 'Anthropic'
        category: 'AIConfig'
      }
    }
  }
]

resource openAISecretRef 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  parent: appConfig
  name: 'AI:OpenAI:ApiKey'
  properties: {
    value: '{"uri": "${keyVaultUri}secrets/AI--OpenAI--ApiKey"}'
    contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
    tags: {
      provider: 'OpenAI'
      category: 'AISecretRef'
    }
  }
}

resource anthropicSecretRef 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  parent: appConfig
  name: 'AI:Anthropic:ApiKey'
  properties: {
    value: '{"uri": "${keyVaultUri}secrets/AI--Anthropic--ApiKey"}'
    contentType: 'application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8'
    tags: {
      provider: 'Anthropic'
      category: 'AISecretRef'
    }
  }
}

output appConfigName string = appConfigName
