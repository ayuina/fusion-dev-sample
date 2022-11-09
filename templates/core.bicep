param prefix string
param region string
@secure()
param adminPassword string

var logAnalyticsName = '${prefix}-laws'
var keyvaultName = '${prefix}-kv'

var vnetName = '${prefix}-vnet'
var vnetRange = '10.1.0.0/16'
var apimSubnetName = 'apimSubnet'
var apimSubnetRange = '10.1.0.0/24'
var apiIaaSSubnetName = 'iaasSubnet'
var apiIaaSSubnetRange = '10.1.1.0/24'

var apimNetworkRequirements = [
  { direction: 'Inbound', priority:1000, access: 'Allow', name: 'ClientCallApi' 
      protocol:'Tcp', source: 'Internet', sourcePort: '*', destination:'VirtualNetwork', destPorts:['80', '443']}
  { direction: 'Inbound', priority:1010, access: 'Allow', name: 'ManagementEndpoint' 
      protocol:'Tcp', source: 'ApiManagement', sourcePort: '*', destination:'VirtualNetwork', destPorts:['3443']}
  { direction: 'Inbound', priority:1020, access: 'Allow', name: 'LoadBalancer' 
      protocol:'Tcp', source: 'AzureLoadBalancer', sourcePort: '*', destination:'VirtualNetwork', destPorts:['6390']}

  { direction: 'Inbound', priority:2100, access: 'Allow', name: 'CacheForeRedisExternal' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['6380']}
  { direction: 'Inbound', priority:2110, access: 'Allow', name: 'CacheForeRedisInternal' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['6381','6382','6383']}
  { direction: 'Inbound', priority:2120, access: 'Allow', name: 'RateLimitPolicySyncCounter' 
      protocol:'Udp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['4290']}

  { direction: 'Outbound', priority:1000, access: 'Allow', name: 'StorageDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'Storage', destPorts:['443']}
  { direction: 'Outbound', priority:1010, access: 'Allow', name: 'AzureADDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'AzureActiveDirectory', destPorts:['443']}
  { direction: 'Outbound', priority:1020, access: 'Allow', name: 'SqlDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'SQL', destPorts:['1433']}
  { direction: 'Outbound', priority:1030, access: 'Allow', name: 'KeyVaultDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'AzureKeyVault', destPorts:['443']}

  { direction: 'Outbound', priority:2000, access: 'Allow', name: 'EventHubDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'EventHub', destPorts:['5671', '5672', '443']}
  { direction: 'Outbound', priority:2010, access: 'Allow', name: 'StorageFilesDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'Storage', destPorts:['445']}
  { direction: 'Outbound', priority:2020, access: 'Allow', name: 'AzureCloudDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'AzureCloud', destPorts:['443', '12000']}
  { direction: 'Outbound', priority:2030, access: 'Allow', name: 'AzureMonitorDependency' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'AzureMonitor', destPorts:['443', '1886']}

  { direction: 'Outbound', priority:2100, access: 'Allow', name: 'CacheForeRedisExternal' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['6380']}
  { direction: 'Outbound', priority:2110, access: 'Allow', name: 'CacheForeRedisInternal' 
      protocol:'Tcp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['6381','6382','6383']}
  { direction: 'Outbound', priority:2120, access: 'Allow', name: 'RateLimitPolicySyncCounter' 
      protocol:'Udp', source: 'VirtualNetwork', sourcePort: '*', destination:'VirtualNetwork', destPorts:['4290']}
]

resource apimNsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: '${vnetName}-${apimSubnetName}-nsg'
  location: region
}

resource secRules 'Microsoft.Network/networkSecurityGroups/securityRules@2022-05-01' = [for rule in apimNetworkRequirements : {
  parent: apimNsg
  name: '${rule.access}-${rule.direction}-${rule.name}'
  properties: {
    access: rule.access
    direction: rule.direction
    priority: rule.priority
    protocol: rule.protocol
    sourceAddressPrefix: rule.source
    sourcePortRange: rule.sourcePort
    destinationAddressPrefix: rule.destination
    destinationPortRanges: rule.destPorts
  }
}]

resource apivmNsg 'Microsoft.Network/networkSecurityGroups@2022-05-01' ={
  name: '${vnetName}-${apiIaaSSubnetName}-nsg'
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
    subnets: [
      {
        name: apimSubnetName
        properties:{
          addressPrefix: apimSubnetRange
          networkSecurityGroup: { id: apimNsg.id }
        }
      }
      {
        name: apiIaaSSubnetName
        properties:{
          addressPrefix: apiIaaSSubnetRange
          networkSecurityGroup: { id: apivmNsg.id }
        }
      }
    ]
  }
}

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: region
  properties:{
    sku:{
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource akv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyvaultName
  location: region
  properties:{
    sku:{
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enableSoftDelete: false
    publicNetworkAccess: 'Enabled'
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    accessPolicies: []
  }
}

resource secret1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: akv
  name: 'adminPassword'
  properties:{
    value: adminPassword
  }
}

output logAnalyticsWorkspaceName string = logAnalyticsName
output keyvaultName string = keyvaultName
output apiIaasSubnetId string = filter(vnet.properties.subnets, s => s.name == apiIaaSSubnetName)[0].id
output apimSubnetId string = filter(vnet.properties.subnets, s => s.name == apimSubnetName)[0].id
