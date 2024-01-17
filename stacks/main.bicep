targetScope = 'managementGroup'

param location string = deployment().location

var config = loadJsonContent('../config.json')

module rg 'modules/rg.bicep' = [for subscriptionId in config.stacks.targetSubscriptions: {
  name: 'deploy_${config.resourceGroupName}'
  scope: subscription(subscriptionId)
  params: {
    name: config.routeTableName
    location: location
    nextHopIpAddress: config.nextHopIpAddress
    resourceGroupName: config.resourceGroupName
  }
}]
