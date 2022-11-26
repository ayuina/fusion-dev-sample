param definitionName string = 'ManagedTodoApi'
param packageUrl string
param region string = 'japaneast'
param readerPrincipalId string
param contributorPrincipalId string

//var ownerRoleId = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
var contributorRoleId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var readerRoleId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'

resource managedAppDef 'Microsoft.Solutions/applicationDefinitions@2021-07-01' = {
  name: definitionName
  location: region
  properties: {
    lockLevel: 'ReadOnly'
    displayName: 'Todo API on Azure PaaS'
    description: 'Azure App Service と SQL Database で実装された Todo API のサンプルを提供するアプリです。'   
    packageFileUri: packageUrl
    managementPolicy: { mode: 'Managed'}
    lockingPolicy:{
      allowedActions: []
      allowedDataActions: []
    }
    notificationPolicy: null
    deploymentPolicy: { deploymentMode: 'Incremental' }
    authorizations: [
      {
        principalId: readerPrincipalId
        roleDefinitionId: readerRoleId
      }
      {
        principalId: contributorPrincipalId
        roleDefinitionId: contributorRoleId
      }
    ]

  }
}
