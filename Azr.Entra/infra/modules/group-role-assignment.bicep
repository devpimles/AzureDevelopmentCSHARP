extension microsoftGraphV1 

param audienceId string
param resourceId string
param roleId string

resource assignment 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
  principalId: audienceId
  resourceId: resourceId
  appRoleId: roleId
}
