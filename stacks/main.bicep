targetScope = 'managementGroup'

param location string = deployment().location

var config = loadJsonContent('../config.json')

module rg 'modules/rg.bicep' = [for subscriptionId in config.stacks.targetSubscriptions: {
  name: 'deploy_${config.resourceGroupName}'
  scope: subscription(subscriptionId)
  params: {
    location: location
    resourceGroupName: config.resourceGroupName
    routeTableName: config.routeTableName
    nextHopIpAddress: config.nextHopIpAddress
  }
}]
