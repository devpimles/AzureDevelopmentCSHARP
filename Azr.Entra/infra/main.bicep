type EnvironmentConfigType = {
  appApi: {
    name: string
    apiUri: string
  }
  appClient: {
    name: string
    redirectUris: array 
    apiServicePrincipalId: string
  }
  groupReader: {
    name: string
  }
  groupWriter: {
    name: string
  }
}

param customerId string
param EnvironmentConfig EnvironmentConfigType

var roleReaderId = guid(customerId, 'role-reader')
var roleWriterId = guid(customerId, 'role-writer')
var scopeReadId  = guid(customerId, 'scope-read')
var scopeWriteId = guid(customerId, 'scope-write')

module apiApp './modules/api-app.bicep' = {
  name: 'apiApp'
  params: {
    customerId: customerId
    name: EnvironmentConfig.appApi.name
    roleReaderId: roleReaderId
    roleWriterId: roleWriterId
    scopeReadId: scopeReadId
    scopeWriteId: scopeWriteId
    apiUri: EnvironmentConfig.appApi.apiUri
  }
}

module clientApp './modules/client-app.bicep' = {
  name: 'clientApp'
  params: {
    customerId: customerId
    name: EnvironmentConfig.appClient.name
    redirectUris: EnvironmentConfig.appClient.redirectUris
    apiServicePrincipalId: apiApp.outputs.apiAppServicePrincipalId
    scopeReadId: scopeReadId
    scopeWriteId: scopeWriteId
  }
}

module readerGroup './modules/group.bicep' = {
  name: 'readerGroup'
  params: {
    customerId: customerId
    name: EnvironmentConfig.groupReader.name
  }
}

module writerGroup './modules/group.bicep' = {
  name: 'writerGroup'
  params: {
    customerId: customerId
    name: EnvironmentConfig.groupWriter.name
  }
}

module readerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'readerRoleAssignment'
  params: {
    audienceId: readerGroup.outputs.groupId
    resourceId: apiApp.outputs.apiAppServicePrincipalId
    roleId: roleReaderId
  }
}

module writerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'writerRoleAssignment'
  params: {
    audienceId: writerGroup.outputs.groupId
    resourceId: apiApp.outputs.apiAppServicePrincipalId
    roleId: roleWriterId
  }
}

output readerGroupId string = readerGroup.outputs.groupId
output writerGroupId string = writerGroup.outputs.groupId
output apiAppServicePrincipalId string = apiApp.outputs.apiAppServicePrincipalId
output apiAppApplicationId string = apiApp.outputs.apiAppApplicationId
output clientAppServicePrincipalId string = clientApp.outputs.clientAppServicePrincipalId
output clientAppApplicationId string = clientApp.outputs.clientAppApplicationId
output readerGroupMailNickName string = readerGroup.outputs.mailNickName
output writerGroupMailNickName string = writerGroup.outputs.mailNickName

