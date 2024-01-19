targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'audit_vnet_egress_controls'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    displayName: 'Control vnet egress (audit only)'
    description: 'Audit if vnet egress traffic is controlled with a route table.'
    parameters: {
      location: loadJsonContent('../rules/_parameters.json').location
      allowedLocations: loadJsonContent('../rules/_parameters.json').allowedLocations
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'vnet_in_allowed_locations')
        parameters: {
          effect: {
            value: 'audit'
          }
          allowedLocations: {
            value: '[parameters(\'allowedLocations\')]'
          }
        }
      }
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
          location: {
            value: '[parameters(\'location\')]'
          }
          nextHopIpAddress: {
            value: '[parameters(\'nextHopIpAddress\')]'
          }
        }
      }
    ]
  }
}
