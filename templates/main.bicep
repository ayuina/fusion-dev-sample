targetScope = 'subscription'

param prefix string = 'fd1109a'
param region string = 'japaneast'

param adminName string = prefix
@secure()
param adminPassword string
param deploymentId string = '${dateTimeToEpoch(utcNow())}'

resource mainrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${prefix}-rg'
  location: region
}

module core 'core.bicep' = {
  name: 'core-${deploymentId}'
  scope: mainrg
  params: {
    prefix: prefix
    region: region
    adminPassword: adminPassword
  }
}

resource laws 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: core.outputs.logAnalyticsWorkspaceName
  scope: mainrg
}

module apim 'apim.bicep' = {
  name: 'apim-${deploymentId}'
  scope: mainrg
  params: {
    prefix: prefix
    region: region
    subnetid: core.outputs.apimSubnetId
  }
}

module todoapi 'todoapi.bicep' = {
  name: 'todo-${deploymentId}'
  scope: mainrg
  params:{
    prefix: '${prefix}-todo'
    region: region
    iaasSubnetId : core.outputs.apiIaasSubnetId
    adminName: adminName
    logAnalyticsWorkspaceId: laws.id
    keyVaultName: core.outputs.keyvaultName
  }
}


