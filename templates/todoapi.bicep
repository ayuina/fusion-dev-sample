param prefix string
param region string
param logAnalyticsWorkspaceId string
param adminName string
param keyVaultName string

var appInsightsName = '${prefix}-ai'

resource akv 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource appinsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: region
  kind: 'web'
  properties:{
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

module apiAppSvc 'todoapi-appservice.bicep' = {
  name: '${deployment().name}-appsvc'
  params: {
    prefix: prefix
    region: region
    adminName: adminName
    adminSqlPassword: akv.getSecret('adminPassword')
    appInsightsName: appInsightsName
  }
  dependsOn: [ appinsights ]
}

module todoapiVm 'todoapi-vm.bicep' = {
  name: '${deployment().name}-vm'
  params: {
    prefix: prefix
    region: region
    adminName: adminName
    adminPassword: akv.getSecret('adminPassword')
  }
  dependsOn: [ appinsights ]
}

output appInsightsName string = appInsightsName
