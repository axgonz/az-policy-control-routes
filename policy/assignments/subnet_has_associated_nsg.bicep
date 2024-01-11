targetScope = 'managementGroup'

@description('Target Management Group')
param managementGroupName string

var name = 'subnet_has_associated_nsg'
var scope = tenantResourceId('Microsoft.Management/managementGroups', managementGroupName)

resource assignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: name
  properties: {
    policyDefinitionId: extensionResourceId(scope, 'Microsoft.Authorization/policyDefinitions', name)
  }
}
