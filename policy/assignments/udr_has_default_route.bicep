targetScope = 'managementGroup'

@description('Target Management Group')
param managementGroupName string

var name = 'udr_has_default_route'
var scope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: name
  properties: {
    parameters: {
      nextHopIpAddress: {
        value: '10.0.0.4'
      }
    }
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', name)
  }
}
