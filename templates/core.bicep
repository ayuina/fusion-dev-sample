param prefix string
param region string
@secure()
param adminPassword string

var logAnalyticsName = '${prefix}-laws'
var keyvaultName = '${prefix}-kv'

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
