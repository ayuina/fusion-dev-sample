
param prefix string = 'ayuina1121'
param region string = 'japaneast'
@secure()
param adminSqlPassword string

module webdb '../webdb.bicep' = {
  name: 'webdb'
  params:{
    prefix: prefix
    region: region
    adminName: prefix
    adminSqlPassword: adminSqlPassword
    loganaWorkspaceId: ''
  }
}

output webapiEndpoint string = webdb.outputs.webapiEndpoint
output kuduEndpoint string = webdb.outputs.kuduEndpoint
