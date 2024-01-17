targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'audit_vnet_egress_contro'
  properties: {
    displayName: 'Control vnet egress (audit only)'
    parameters: {
      nextHopIpAddress: {
        value: config.nextHopIpAddress
      }
    }
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policySetDefinitions', 'audit_vnet_egress_controls')
  }
}
