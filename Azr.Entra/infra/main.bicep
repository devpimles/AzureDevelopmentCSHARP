var suffix = uniqueString(subscription().id, resourceGroup().id)

module apiApp './modules/api-app.bicep' = {
  name: 'apiApp'
  params: {
    name: 'api-app-${suffix}'
  }
}

module clientApp './modules/client-app.bicep' = {
  name: 'clientApp'
  params: {
    name: 'client-app-${suffix}'
    apiApplicationId: apiApp.outputs.apiApplicationId
    scopeReadId: apiApp.outputs.scopeReadId
    scopeWriteId: apiApp.outputs.scopeWriteId
  }
}

module readerGroup './modules/group.bicep' = {
  name: 'readerGroup'
  params: {
    name: 'grp-test-reader-${suffix}'
  }
}

module writerGroup './modules/group.bicep' = {
  name: 'writerGroup'
  params: {
    name: 'grp-test-writer-${suffix}'
  }
}

module readerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'readerRoleAssignment'
  params: {
    servicePrincipalId: apiApp.outputs.apiServicePrincipalId
    groupId: readerGroup.outputs.groupId
    appRoleId: apiApp.outputs.roleReaderId
  }
}

module writerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'writerRoleAssignment'
  params: {
    servicePrincipalId: apiApp.outputs.apiServicePrincipalId
    groupId: writerGroup.outputs.groupId
    appRoleId: apiApp.outputs.roleWriterId
  }
}

output apiApplicationId string = apiApp.outputs.apiServicePrincipalId
output clientApplicationId string = clientApp.outputs.clientApplicationId
output readerGroupId string = readerGroup.outputs.groupId
output writerGroupId string = writerGroup.outputs.groupId
