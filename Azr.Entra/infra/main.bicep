type EnvironmentConfigType = {
  appApi: {
    name: string
    uniqueName: string
    roleReaderId: string
    roleWriterId: string
    scopeReadId: string
    scopeWriteId: string
    apiUri: string
  }
  appclient: {
    name: string
    uniqueName: string
    redirectUris: array 
    apiServicePrincipalId: string
    apiScopeReadId: string
    apiScopeWriteId: string
  }
  groupReader: {
    displayName: string
    uniqueName: string
    mailEnabled: bool
    mailNickname: string
    securityEnabled: bool
  }
  groupWriter: {
    displayName: string
    uniqueName: string
    mailEnabled: bool
    mailNickname: string
    securityEnabled: bool
  }
}

param EnvironmentConfig EnvironmentConfigType

module apiApp './modules/api-app.bicep' = {
  name: 'apiApp'
  params: {
    name: EnvironmentConfig.appApi.name
    uniqueName: EnvironmentConfig.appApi.uniqueName
    roleReaderId: EnvironmentConfig.appApi.roleReaderId
    roleWriterId: EnvironmentConfig.appApi.roleWriterId
    scopeReadId: EnvironmentConfig.appApi.scopeReadId
    scopeWriteId: EnvironmentConfig.appApi.scopeWriteId
    apiUri: EnvironmentConfig.appApi.apiUri
  }
}

module clientApp './modules/client-app.bicep' = {
  name: 'clientApp'
  params: {
    name: EnvironmentConfig.appclient.name
    uniqueName: EnvironmentConfig.appclient.uniqueName
    redirectUris: EnvironmentConfig.appclient.redirectUris
    apiServicePrincipalId: apiApp.outputs.apiServicePrincipalId
    apiScopeReadId: EnvironmentConfig.appclient.apiScopeReadId
    apiScopeWriteId: EnvironmentConfig.appclient.apiScopeWriteId
  }
}

module readerGroup './modules/group.bicep' = {
  name: 'readerGroup'
  params: {
    displayName: EnvironmentConfig.groupReader.displayName
    uniqueName: EnvironmentConfig.groupReader.uniqueName
    mailEnabled: EnvironmentConfig.groupReader.mailEnabled
    mailNickname: EnvironmentConfig.groupReader.mailNickname
    securityEnabled: EnvironmentConfig.groupReader.securityEnabled
  }
}

module writerGroup './modules/group.bicep' = {
  name: 'writerGroup'
  params: {
    displayName: EnvironmentConfig.groupWriter.displayName
    uniqueName: EnvironmentConfig.groupWriter.uniqueName
    mailEnabled: EnvironmentConfig.groupWriter.mailEnabled
    mailNickname: EnvironmentConfig.groupWriter.mailNickname
    securityEnabled: EnvironmentConfig.groupWriter.securityEnabled
  }
}

module readerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'readerRoleAssignment'
  params: {
    audienceId: readerGroup.outputs.groupId
    resourceId: apiApp.outputs.apiServicePrincipalId
    roleId: apiApp.outputs.roleReaderId
  }
}

module writerRoleAssignment './modules/group-role-assignment.bicep' = {
  name: 'writerRoleAssignment'
  params: {
    audienceId: writerGroup.outputs.groupId
    resourceId: apiApp.outputs.apiServicePrincipalId
    roleId: apiApp.outputs.roleWriterId
  }
}
