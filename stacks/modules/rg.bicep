targetScope = 'subscription'

param name string
param location string
param nextHopIpAddress string
param resourceGroupName string

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module routeTable 'udr.bicep' = {
  name: 'deploy_${name}'
  scope: rg
  params: {
    name: name
    location: location
    nextHopIpAddress: nextHopIpAddress
  }
}
