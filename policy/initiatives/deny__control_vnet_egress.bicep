targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')
var scope = tenantResourceId('Microsoft.Management/managementGroups', config.managementGroupName)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'control_vnet_egress'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    displayName: 'Control vnet egress'
    description: 'Stop deployments of subnets without a properly configured route table.'
    parameters: {
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'subnet_is_associated_with_desired_udr')
        parameters: {
          effect: {
            value: 'deny'
          }
          routeTableName: {
            value: config.routeTableName
          }
          resourceGroupName: {
            value: config.resourceGroupName
          }
        }
      }      
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_bgp_propagation_disabled')
        parameters: {
          effect: {
            value: 'deny'
          }
        }
      }
      { 
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_default_route')
        parameters: {
          effect: {
            value: 'deny'
          }
          nextHopIpAddress: {
            value: '[parameters(\'nextHopIpAddress\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_only_one_route')
        parameters: {
          effect: {
            value: 'deny'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'subscription_has_policy_controlled_udr')
        parameters: {
          resourceGroupName: {
            value: config.resourceGroupName
          }
          routeTableName: {
            value: config.routeTableName
          }          
          nextHopIpAddress: {
            value: '[parameters(\'nextHopIpAddress\')]'
          }
        }
      }          
    ]
  }
}
