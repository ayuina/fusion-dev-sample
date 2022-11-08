param prefix string
param region string
param adminName string
@secure()
param adminPassword string

var vnetName = '${prefix}-vnet'
var vnetRange = '10.1.0.0/16'
var apimSubnetName = 'apimSubnet'
var apimSubnetRange = '10.1.0.0/24'
var apiVmSubnetName = 'default'
var apiVmSubnetRange = '10.1.1.0/24'
var vmName = '${prefix}-vm'
var nicName = '${vmName}-nic'
var pipName = '${vmName}-pip'

resource apimNsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' ={
  name: '${vnetName}-${apimSubnetName}-nsg'
  location: region
}

resource apivmNsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' ={
  name: '${vnetName}-${apiVmSubnetName}-nsg'
  location: region
}

resource allowHttpInbound 'Microsoft.Network/networkSecurityGroups/securityRules@2022-05-01' = {
  parent: apivmNsg
  name: 'AllowHttpFromVnet'
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    priority: 1000
    protocol: 'TCP'
    sourceAddressPrefix: 'VirtualNetwork'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    destinationPortRanges: ['80', '443']
  }
}

resource allowSshFromInternet 'Microsoft.Network/networkSecurityGroups/securityRules@2022-05-01' = {
  parent: apivmNsg
  name: 'AllowSshFromInternet'
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    priority: 1100
    protocol: 'TCP'
    sourceAddressPrefix: 'Internet'
    sourcePortRange: '*'
    destinationAddressPrefix: '*'
    destinationPortRanges: ['22']
  }
}


resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [ vnetRange ]
    }
    subnets: [
      {
        name: apimSubnetName
        properties:{
          addressPrefix: apimSubnetRange
          networkSecurityGroup: { id: apimNsg.id }
        }
      }
      {
        name: apiVmSubnetName
        properties:{
          addressPrefix: apiVmSubnetRange
          networkSecurityGroup: { id: apivmNsg.id }
        }
      }
    ]
  }
}

resource apiVmSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing = {
  name: apiVmSubnetName
  parent: vnet
}

resource pip 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: pipName
  location: region
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: { domainNameLabel: vmName }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  location: region
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: apiVmSubnet.id
          }
        }
      }
    ]
  }
}

resource apivm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: region
  properties: {
    hardwareProfile: { vmSize: 'Standard_B1s' }
    osProfile: {
      computerName: vmName
      adminUsername: adminName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: { 
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks:[]
    }
    networkProfile: {
      networkInterfaces:[ {id: nic.id} ]
    }
  }
}

output vnetName string = vnetName
output apimSubnetName string = apimSubnetName
output apiVmSubnetName string = apiVmSubnetName
output vmHost string = pip.properties.dnsSettings.fqdn
