extension microsoftGraphV1 

@description('The service principal ID to assign the role to.')
param servicePrincipalId string

@description('The group ID to assign the role to.')
param groupId string

@description('The app role ID to assign.')
param appRoleId string

resource assignment 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
  principalId: groupId
  resourceId: servicePrincipalId
  appRoleId: appRoleId
}
