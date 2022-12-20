param prefix string = 'fd1126'
param region string = 'japaneast'

var apiManagementName = '${prefix}-apim'
var logAnalyticsName = '${apiManagementName}-laws'
var pipName = '${apiManagementName}-pip'
var appInsightsName = '${apiManagementName}-ai'

var vnetName = '${apiManagementName}-vnet'
var vnetRange = '10.1.0.0/16'
var apimSubnetName = 'apimSubnet'
var apimSubnetRange = '10.1.0.0/24'


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
    ]
  }
}

resource apimSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-05-01' existing = {
  parent: vnet
  name: apimSubnetName
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

resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}



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
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherName: prefix
    publisherEmail: '${prefix}@${prefix}.local'

    publicIpAddressId: pip.id
    virtualNetworkType: 'External'
    virtualNetworkConfiguration: {
      subnetResourceId: apimSubnet.id
    }
  }
}

resource aiLogger 'Microsoft.ApiManagement/service/loggers@2022-04-01-preview' = {
  name: '${appInsightsName}-logger'
  parent: apimanagement
  properties: {
    loggerType: 'applicationInsights'
    resourceId: appinsights.id
    credentials: {
      instrumentationKey: appinsights.properties.InstrumentationKey
    }
  }
}

resource ailogging 'Microsoft.ApiManagement/service/diagnostics@2022-04-01-preview' = {
  name: 'applicationinsights'
  parent: apimanagement
  properties: {
    loggerId: aiLogger.id
    alwaysLog: 'allErrors'
    logClientIp: true
    verbosity: 'verbose'
  }
}

resource apimDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${apimanagement.name}-diag'
  scope: apimanagement
  properties: {
    workspaceId: logAnalytics.id
    logAnalyticsDestinationType: 'Dedicated'
    logs: [
      {
        category: 'GatewayLogs'
        enabled: true
      }
      {
        category: 'WebSocketConnectionLogs'
        enabled: true
      }
    ]
    metrics: [
      {
         category: 'AllMetrics'
         enabled: true
      }
    ]
  }

}


output apiManagementName string = apiManagementName
output logAnalyticsWorkspaceId string = logAnalytics.id
