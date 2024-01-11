targetScope = 'managementGroup'

@description('Target Management Group')
param managementGroupName string

var name = 'allowed_locations'
var scope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: name
  properties: {
    parameters: {
      allowedLocations: {
        value: ['australiaeast', 'australiasoutheast']
      }
    }
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', name)
  }
}
