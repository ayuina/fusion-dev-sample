param prefix string = 'fd1107b'
param region string = 'japaneast'

var apiManagementName = '${prefix}-apim'
var logAnalyticsName = '${prefix}-laws'
var appInsightsName = '${prefix}-ai'
var backendAppSvcName = '${prefix}-web'
var backendAppSvcPlanName = '${prefix}-asp'


resource laws 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
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

resource ai 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  kind: 'web'
  properties:{
    Application_Type: 'web'
    WorkspaceResourceId: laws.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
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

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: backendAppSvcPlanName
  location: region
  sku: {
    name: 'S1'
    capacity: 1
  }
}

resource web 'Microsoft.Web/sites@2022-03-01' = {
  name: backendAppSvcName
  location: region
  properties:{
    serverFarmId: asp.id
  }
}
