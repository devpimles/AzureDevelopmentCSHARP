extension microsoftGraphV1 

param displayName string
param uniqueName string
param mailEnabled bool
param mailNickname string
param securityEnabled bool

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: displayName
  uniqueName: uniqueName
  mailEnabled: mailEnabled
  mailNickname: mailNickname
  securityEnabled: securityEnabled
}

output groupId string = group.id
