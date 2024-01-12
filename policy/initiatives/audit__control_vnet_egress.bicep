targetScope = 'managementGroup'

param managementGroupName string = 'policy_definitions'
var scope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'audit_vnet_egress_controls'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    displayName: 'Control vnet egress (audit only)'
    description: 'Audit if vnet egress traffic is controlled with a route table.'
    parameters: {
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'subnet_has_associated_udr')
        parameters: {
          effect: {
            value: 'audit'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_forces_next_hop')
        parameters: {
          effect: {
            value: 'audit'
          }
          nextHopIpAddress: {
            value: '[parameters(\'nextHopIpAddress\')]'
          }
        }
      }   
    ]
  }
}
