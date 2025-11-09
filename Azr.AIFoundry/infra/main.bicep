@description('Location for the AI Foundry resources.')
param location string = resourceGroup().location

@description('Unique name for the AI Foundry account.')
param aiFoundryName string

@description('Name of the project to create under the Foundry.')
param aiProjectName string = '${aiFoundryName}-proj'

module aiFoundryModule 'modules/aifoundry.bicep' = {
  name: 'deploy-ai-foundry'
  params: {
    aiFoundryName: aiFoundryName
    aiProjectName: aiProjectName
    location: location
  }
}

output aiFoundryName string = aiFoundryModule.outputs.aiFoundryName
output aiProjectName string = aiFoundryModule.outputs.aiProjectName
