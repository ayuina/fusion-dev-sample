param prefix string = 'ayuina1125c'
param region string = 'japaneast'
param adminName string = prefix
@secure()
param adminPassword string

var vnetName = '${prefix}-vnet'
var vnetRange = '10.99.99.0/24'
var vmSubnetName = 'default'
var vmSubnetRange = '10.99.99.0/24'

var vmName = '${prefix}-vm'
var nicName = '${vmName}-nic'
var pipName = '${vmName}-pip'

resource vmSubnetNsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' ={
  name: '${vnetName}-${vmSubnetName}-nsg'
  location: region
  properties: {
    securityRules:[
      {
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
      {
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
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: region
  properties: {
    addressSpace: {
      addressPrefixes: [ vnetRange ]
    }
  }
}

resource vmSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' = {
  parent: vnet
  name: vmSubnetName
  properties: {
    addressPrefix: vmSubnetRange
    networkSecurityGroup: {id: vmSubnetNsg.id}
  }
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
            id: vmSubnet.id
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

resource scriptExt 'Microsoft.Compute/virtualMachines/extensions@2022-08-01' = {
  parent: apivm
  location: region
  name: 'setup-api'
  properties:{
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    protectedSettings: { 
      commandToExecute : ''
    }
  }
}

output vmHost string = pip.properties.dnsSettings.fqdn
