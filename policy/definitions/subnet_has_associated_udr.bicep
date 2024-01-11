targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subnet_has_associated_udr'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: loadJsonContent('../rules/subnet_has_associated_udr.p.json')
    policyRule: loadJsonContent('../rules/subnet_has_associated_udr.json')
  }
}
