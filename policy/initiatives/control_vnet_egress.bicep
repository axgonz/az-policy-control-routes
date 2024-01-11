targetScope = 'managementGroup'

param managementGroupName string = 'policy_definitions'
var scope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2023-04-01' = {
  name: 'control_vnet_egress'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    displayName: 'Control vnet egress'
    description: 'Force vnet egress traffic to a desired NVA.'
    parameters: {
      effect: {
        type: 'string'
        metadata: {
            description: 'Selecting \'deny\' will prevent non-compliant resources from being deployed.'
            type: 'string'
            displayName: 'Effect - audit/deny'
            defaultValue: 'audit'
            allowedValues: [
                'audit'
                'deny'
            ]
        }
      }
      nextHopIpAddress: {
        type: 'string'
        metadata: {
          description: 'The next hop IP address to be used with the default route address prefix.'
          displayName: 'Next hop IP address'
        }
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'subnet_has_associated_udr')
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      {
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_bgp_propagation_disabled')
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
          }
        }
      }
      { 
        policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', 'udr_has_default_route')
        parameters: {
          effect: {
            value: '[parameters(\'effect\')]'
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
            value: '[parameters(\'effect\')]'
          }
        }
      }    
    ]
  }
}
