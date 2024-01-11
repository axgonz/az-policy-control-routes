targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'udr_has_only_one_route'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: loadJsonContent('../rules/udr_has_only_one_route.p.json')
    policyRule: loadJsonContent('../rules/udr_has_only_one_route.json')
  }
}
