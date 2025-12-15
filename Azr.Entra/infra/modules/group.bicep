extension microsoftGraphV1 

@description('The name of the group.')
param name string

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: name
  mailEnabled: false
  mailNickname: uniqueString(name)
  securityEnabled: true
  uniqueName: 'users_group_2025_12_09'
}

output groupName string = name
output groupId string = group.id
