@description('The suffix to append to the API Management instance name. Defaults to a unique string based on subscription and resource group IDs.')
param suffix string

@description('The location of the API Management instance. Defaults to the resource group location.')
param location string

@description('The pricing tier of this API Management service')
param sku string

@description('The instrumentation key for Application Insights')
param appInsightsInstrumentationKey string

@description('The resource ID for Application Insights')
param appInsightsId string

resource apimService 'Microsoft.ApiManagement/service@2024-06-01-preview' = {
  name: 'apim-${suffix}'
  location: location
  sku: {
    name: sku
    capacity: 1
  }
  properties: {
    publisherEmail: 'pedromonteiroleite@gmail.com'
    publisherName: 'Pedro Leite'
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource apimLogger 'Microsoft.ApiManagement/service/loggers@2021-12-01-preview' = if (!empty(appInsightsId) && !empty(appInsightsInstrumentationKey)) {
  name: 'apim-logger'
  parent: apimService
  properties: {
    credentials: {
      instrumentationKey: appInsightsInstrumentationKey
    }
    description: 'APIM Logger for OpenAI API'
    isBuffered: false
    loggerType: 'applicationInsights'
    resourceId: appInsightsId
  }
}

output id string = apimService.id
output name string = apimService.name
output principalId string = apimService.identity.principalId
output gatewayUrl string = apimService.properties.gatewayUrl
