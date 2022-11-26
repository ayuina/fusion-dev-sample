param prefix string = 'fd1126'
param region string = 'japaneast'
param apimSubnetId string
param logAnalyticsId string

var apiManagementName = '${prefix}-apim'
var pipName = '${apiManagementName}-pip'
var appInsightsName = '${apiManagementName}-ai'

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
      subnetResourceId: apimSubnetId
    }
  }
}

resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
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
    workspaceId: logAnalyticsId
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
