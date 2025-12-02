param location string = resourceGroup().location
var suffix = uniqueString(subscription().id, resourceGroup().id)

type EnvironmentConfigType = {
  law: {
    sku: string
  }
}

param EnvironmentConfig EnvironmentConfigType

module lawModule './modules/law.bicep' = {
  name: 'lawModule'
  params: {
    suffix: suffix
    location: location
    sku: EnvironmentConfig.law.sku
  }
}

module appInsightsModule './modules/appinsights.bicep' = {
  name: 'appInsightsModule'
  params: {
    suffix: suffix
    location: location
    lawId: lawModule.outputs.lawId
  }
}
