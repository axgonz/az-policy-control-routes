targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'control_vnet_egress'
  properties: {
    displayName: 'Control vnet egress'
    parameters: {
      nextHopIpAddress: {
        value: config.nextHopIpAddress
      }
      excludedSubnets: {
        value: config.excludedSubnets
      }
    }
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policySetDefinitions', 'control_vnet_egress')
  }
}
