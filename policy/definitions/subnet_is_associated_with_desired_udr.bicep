targetScope = 'managementGroup'

resource definition 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'subnet_is_associated_with_desired_udr'
  properties: {
    metadata: {
      version: '1.0.0'
      category: 'algonz'
    }
    policyType: 'Custom'
    mode: 'all'
    parameters: {
      effect: loadJsonContent('../rules/_parameters.json').effect
      routeTableName: loadJsonContent('../rules/_parameters.json').routeTableName
      resourceGroupName: loadJsonContent('../rules/_parameters.json').resourceGroupName
    }
    policyRule: {
      if: loadJsonContent('../rules/subnet_is_missing_desired_udr.json').if
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}
