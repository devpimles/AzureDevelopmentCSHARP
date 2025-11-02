using 'main.bicep'

param keyVaultName = 'demo-kv-rbac-20250910'
param keyVaultSku = 'standard'
param location = 'westeurope'
param appConfigName = 'demo-app-config-202509110910'
param appConfigSku = 'standard'

param AI = {
  OpenAI: {
    ModelName: 'gpt-4o-mini'
    Temperature: '0.1'
    MaxTokens: 200
    TopP: 1
    FrequencyPenalty: 0
    PresencePenalty: 0
  }
  Anthropic: {
    ModelName: 'claude-3.5-sonnet'
    Temperature: '0.1'
    MaxTokens: 200
    TopK: 30
    TopP: 1
  }
}
