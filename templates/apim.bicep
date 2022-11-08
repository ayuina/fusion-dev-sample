param prefix string
param region string

var apiManagementName = '${prefix}-apim'

resource apimanagement 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: apiManagementName
  location: region
  sku:{
    name: 'Developer'
    capacity: 1
  }
  properties:{
    publisherName: prefix
    publisherEmail: '${prefix}@${prefix}.local'
  }
}

output apiManagementName string = apiManagementName
