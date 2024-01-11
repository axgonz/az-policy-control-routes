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
    parameters: loadJsonContent('../rules/allowed_locations.p.json')
    policyRule: loadJsonContent('../rules/allowed_locations.json')
  }
}
