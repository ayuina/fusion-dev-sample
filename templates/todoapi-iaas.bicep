param prefix string
param region string
param subnetId string
param adminName string
@secure()
param adminPassword string

var vmName = '${prefix}-vm'
var nicName = '${vmName}-nic'
var pipName = '${vmName}-pip'




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
            id: subnetId
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

output vmHost string = pip.properties.dnsSettings.fqdn
