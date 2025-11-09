@description('Unique name for the AI Foundry instance.')
param aiFoundryName string

@description('Name of the project to create under the AI Foundry.')
param aiProjectName string

@description('Azure region for deployment.')
param location string = resourceGroup().location

resource aiFoundry 'Microsoft.CognitiveServices/accounts@2025-04-01-preview' = {
  name: aiFoundryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'S0'
  }
  kind: 'AIServices'
  properties: {
    allowProjectManagement: true
    customSubDomainName: aiFoundryName
    disableLocalAuth: false
  }
}

resource aiProject 'Microsoft.CognitiveServices/accounts/projects@2025-04-01-preview' = {
  name: aiProjectName
  parent: aiFoundry
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  parent: aiFoundry
  name: 'gpt-4o-mini'
  sku: {
    capacity: 1
    name: 'GlobalStandard'
  }
  properties: {
    model: {
      name: 'gpt-4o-mini'
      format: 'OpenAI'
    }
  }
}

output aiFoundryName string = aiFoundry.name
output aiFoundryId string = aiFoundry.id
output aiProjectName string = aiProject.name
output aiProjectId string = aiProject.id
