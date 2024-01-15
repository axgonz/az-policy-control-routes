targetScope = 'managementGroup'

param subscriptionId string
param location string = deployment().location

var config = loadJsonContent('../config.json')

module rg 'modules/rg.bicep' = {
  name: 'deploy_${config.resourceGroupName}'
  scope: subscription(subscriptionId)
  params: {
    name: config.routeTableName
    location: location
    nextHopIpAddress: config.nextHopIpAddress
    resourceGroupName: config.resourceGroupName
  }
}
