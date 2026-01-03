extension microsoftGraphV1 

param name string
var mailNickName = toLower(
  replace(
    guid(customerId, name),
    '-',
    ''
  )
)
param customerId string

resource group 'Microsoft.Graph/groups@v1.0' = {
  displayName: '${name}-${customerId}'
  mailNickname: mailNickName
  uniqueName: '${name}-${customerId}-${uniqueString(customerId)}'
  securityEnabled: true
  mailEnabled: false
}

output groupId string = group.id
output mailNickName string = mailNickName
