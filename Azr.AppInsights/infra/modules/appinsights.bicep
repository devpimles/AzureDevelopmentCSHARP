@description('The suffix to append to the resource name.')
param suffix string

@description('Name of the resource.')
param name string = 'insights-${suffix}'

@description('Location of the Application Insights resource')
param location string

@description('Log Analytics Workspace Id')
param lawId string

@description('Deploy the workbook or skip it.')
param enableWorkbook bool = false

@description('JSON string for the Workbook')
param workbookJson string = ''

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: lawId
  }
}

resource workbook 'Microsoft.Insights/workbooks@2022-04-01' = if (enableWorkbook) {
  name: guid(resourceGroup().id, 'UsageAnalysis')
  location: location
  kind: 'shared'
  properties: {
    displayName: 'Usage Analysis'
    serializedData: workbookJson
    sourceId: applicationInsights.id
    category: 'UsageAnalysis'
  }
}

output id string = applicationInsights.id
output name string = applicationInsights.name
output connectionString string = applicationInsights.properties.ConnectionString
output appId string = applicationInsights.properties.AppId
