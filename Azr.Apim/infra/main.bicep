param location string = resourceGroup().location
var suffix = uniqueString(subscription().id, resourceGroup().id)

param appInsightsInstrumentationKey string
param appInsightsId string

type EnvironmentConfigType = {
  apim: {
    sku: string
  }
}
param EnvironmentConfig EnvironmentConfigType

module apimModule './modules/apim.bicep' = {
  name: 'apimModule'
  params: {
    suffix: suffix
    location: location
    sku: EnvironmentConfig.apim.sku
    appInsightsInstrumentationKey: appInsightsInstrumentationKey
    appInsightsId: appInsightsId
  }
}
