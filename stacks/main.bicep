targetScope = 'subscription'

param location string = deployment().location

var config = loadJsonContent('../config.json')
var shortLocation = config.regionPrefixLookup[location]

var resourceGroupName = config.resourceGroupName
var routeTableName = config.routeTable.name
var nextHopIpAddress = config.nextHopIpAddressLookup[location]

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: '${resourceGroupName}_${shortLocation}'
  location: location
}

module routeTable 'modules/udr.bicep' = {
  name: 'deploy_${routeTableName}_${shortLocation}'
  scope: rg
  params: {
    name: routeTableName
    location: location
    nextHopIpAddress: nextHopIpAddress
  }
}
