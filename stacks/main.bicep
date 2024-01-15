targetScope = 'managementGroup'

param subscriptionId string
param location string = deployment().location

var config = loadJsonContent('../config.json')

module exampleModule 'modules/subscription.bicep' = {
  name: 'deploy_${config.resourceGroupName}'
  scope: subscription(subscriptionId)
  params: {
    name: config.resourceGroupName
    location: location
  }
}
