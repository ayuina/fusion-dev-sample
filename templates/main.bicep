targetScope = 'subscription'

param prefix string = 'fd1108e'
param region string = 'japaneast'

param adminName string = prefix
@secure()
param adminPassword string
param deploymentId string = '${dateTimeToEpoch(utcNow())}'

var rgName = '${prefix}-rg'

/////// base ////////////////////////////////

resource mainrg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
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
  }
}

module todoapi 'todoapi.bicep' = {
  name: 'todo-${deploymentId}'
  scope: mainrg
  params:{
    prefix: prefix
    region: region
    adminName: adminName
    logAnalyticsWorkspaceId: laws.id
    keyVaultName: core.outputs.keyvaultName
  }
}


