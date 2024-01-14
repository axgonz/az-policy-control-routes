targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_has_bgp_propagation_disabled'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      lock: loadJsonContent('../rules/_parameters.json').lock
    }
    policyRule: {
      if: loadJsonContent('../rules/udr_is_missing_resource_lock.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
