targetScope = 'managementGroup'

var config = loadJsonContent('../../config.json')

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_forces_next_hop'
  properties: {
    metadata: {
      version: config.metadata.version
      category: config.metadata.category
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      nextHopIpAddress: loadJsonContent('../rules/_parameters.json').nextHopIpAddress
    }
    policyRule: {
      if: loadJsonContent('../rules/udr_does_not_force_next_hop.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
