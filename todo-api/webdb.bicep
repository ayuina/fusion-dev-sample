param prefix string = 'ayuina'
param region string = 'japaneast'
param loganaWorkspaceId string = ''
param adminName string = prefix
@secure()
param adminSqlPassword string
param runfromPackageUrl string

var appSvcName = '${prefix}-web'
var appSvcPlanName = '${prefix}-asp'
var sqlSvrName = '${prefix}-sqlsvr'
var sqlDbName = '${prefix}-sqldb'
var logAnalyticsName = '${prefix}-laws'
var appInsightsName = '${appSvcName}-ai'

resource logAnalyticsNew 'Microsoft.OperationalInsights/workspaces@2022-10-01' = if(empty(loganaWorkspaceId)) {
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
  properties:{
    Application_Type: 'web'
    WorkspaceResourceId: (empty(loganaWorkspaceId) ? logAnalyticsNew.id : loganaWorkspaceId)
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appSvcPlanName
  location: region
  sku: {
    name: 'S1'
    capacity: 1
  }
}

resource web 'Microsoft.Web/sites@2022-03-01' = {
  name: appSvcName
  location: region
  properties:{
    serverFarmId: asp.id
    clientAffinityEnabled: false
    siteConfig: {
      netFrameworkVersion: 'v7.0'
      ftpsState: 'Disabled'
      use32BitWorkerProcess: false
    }
  }
  tags: {
    amamonitor: 'target'
  }
}

resource metadata 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'metadata'
  parent: web
  properties: {
    CURRENT_STACK: 'dotnet'
  }
}

resource appsettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  parent: web
  properties: {
    WEBSITE_RUN_FROM_PACKAGE: runfromPackageUrl
    APPINSIGHTS_INSTRUMENTATIONKEY: appinsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appinsights.properties.ConnectionString
    ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
    XDT_MicrosoftApplicationInsights_Mode: 'Recommended'
    XDT_MicrosoftApplicationInsights_PreemptSdk: '1'
  }
}

resource sqlsvr 'Microsoft.Sql/servers@2021-11-01' = {
  name: sqlSvrName
  location: region
  properties: {
    administratorLogin: adminName
    administratorLoginPassword: adminSqlPassword
  }
}

resource sqldb 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: sqlDbName
  parent: sqlsvr
  location: region
  sku: {
    name: 'GP_S_Gen5_1'
  }
}

resource sqlconstr 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'connectionstrings'
  parent: web
  properties: {
    sqlconstr : {
      type: 'SQLAzure'
      value: 'Server=tcp:${sqlsvr.properties.fullyQualifiedDomainName},1433; Database=${sqlDbName}; User ID=${adminName}; Password=${adminSqlPassword};Trusted_Connection=False;Encrypt=True;'
    }
  }
}

resource sqlfw 'Microsoft.Sql/servers/firewallRules@2021-11-01' = {
  parent: sqlsvr
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress:'0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}


output webapiEndpoint string = 'https://${web.properties.enabledHostNames[0]}/swagger'
output kuduEndpoint string = 'https://${web.properties.enabledHostNames[1]}'
