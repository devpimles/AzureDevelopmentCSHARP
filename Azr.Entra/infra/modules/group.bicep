extension microsoftGraphV1 

@description('The name of the group.')
param name string

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: name
  mailEnabled: false
  mailNickname: uniqueString(name)
  securityEnabled: true
  uniqueName: replace(toLower(name), '-', '_')
}

output groupName string = name
output groupId string = group.id
