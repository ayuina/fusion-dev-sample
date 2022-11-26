targetScope = 'subscription'

param prefix string = 'fd1126'
param region string = 'japaneast'

param adminName string = prefix
@secure()
param adminPassword string
param deploymentId string = '${dateTimeToEpoch(utcNow())}'

var apppackUrl = 'https://github.com/ayuina/fusion-dev-sample/releases/download/app-v1/webapp.zip'
var appsetupUrl = 'https://github.com/ayuina/fusion-dev-sample/releases/download/app-v1/setup-api.sh'

resource apimrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-apim-rg'
  location: region
}

module apimBase './apimanagement/apim-base.bicep' = {
  name: 'apim-base-${deploymentId}'
  scope: apimrg
  params: {
    prefix: prefix
    region: region
  }
}

module apim './apimanagement/apim.bicep' = {
  name: 'apim-core-${deploymentId}'
  scope: apimrg
  params: {
    prefix: prefix
    region: region
    apimSubnetId: apimBase.outputs.apimSubnetId
  }
}

resource todoPaasRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-todo-paas-rg'
  location: region
}

module todoPaas './todo-api/webdb.bicep' = {
  name: 'todoo-paas-${deploymentId}'
  scope: todoPaasRg
  params:{
    prefix: '${prefix}-todo-paas'
    region: region
    adminName: adminName
    adminSqlPassword: adminPassword
    loganaWorkspaceId: apimBase.outputs.logAnalyticsWorkspaceId
    runfromPackageUrl: apppackUrl
  }
}

resource todoOnpremRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-todo-onprem-rg'
  location: region
}

module todoOnprem './todo-api/onprevm.bicep' = {
  name: 'todo-onprem-${deploymentId}'
  scope: todoOnpremRg
  params: {
    prefix: '${prefix}-todo-iaas'
    region: region
    adminName: adminName
    adminPassword: adminPassword
    loganaWorkspaceId: apimBase.outputs.logAnalyticsWorkspaceId
    setupScriptUri: appsetupUrl
  }
}



// resource akv 'Microsoft.KeyVault/vaults@2022-07-01' = {
//   name: keyvaultName
//   location: region
//   properties:{
//     sku:{
//       family: 'A'
//       name: 'standard'
//     }
//     tenantId: tenant().tenantId
//     enableSoftDelete: false
//     publicNetworkAccess: 'Enabled'
//     enabledForDeployment: true
//     enabledForTemplateDeployment: true
//     accessPolicies: []
//   }
// }

// resource secret1 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//   parent: akv
//   name: 'adminPassword'
//   properties:{
//     value: adminPassword
//   }
// }


