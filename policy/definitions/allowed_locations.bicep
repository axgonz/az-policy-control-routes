targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'allowed_locations'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      allowedLocations: loadJsonContent('../rules/_parameters.json').allowedLocations
    }
    policyRule: {
      if: loadJsonContent('../rules/location_not_in_allowedLocations.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
