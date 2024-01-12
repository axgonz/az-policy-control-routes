targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subnet_has_associated_nsg'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
    }
    policyRule: {
      if: loadJsonContent('../rules/subnet_has_no_nsg.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
