param prefix string
param region string
param appInsightsName string
param adminName string
@secure()
param adminSqlPassword string

var appSvcName = '${prefix}-web'
var appSvcPlanName = '${prefix}-asp'
var sqlSvrName = '${prefix}-sqlsvr'
var sqlDbName = '${prefix}-sqldb'


resource appinsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: appInsightsName
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
      netFrameworkVersion: 'v6.0'
      ftpsState: 'Disabled'
      use32BitWorkerProcess: false
    }
  }
}

resource ext 'Microsoft.Web/sites/siteextensions@2022-03-01' = {
  parent: web
  name: 'Microsoft.ApplicationInsights.AzureWebSites'
  dependsOn: [
    appinsights
  ]
}

resource appsettings 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'appsettings'
  parent: web
  dependsOn:[
    ext
  ]
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appinsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appinsights.properties.ConnectionString
    ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
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

