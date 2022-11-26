param prefix string = 'fd1126'
param region string = 'japaneast'
param apimSubnetId string

var apiManagementName = '${prefix}-apim'
var pipName = '${apiManagementName}-pip'


resource pip 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: pipName
  location: region
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: { domainNameLabel: apiManagementName }
  }
}

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

    publicIpAddressId: pip.id
    virtualNetworkType: 'External'
    virtualNetworkConfiguration:{
      subnetResourceId: apimSubnetId
    }
  }
}


output apiManagementName string = apiManagementName
