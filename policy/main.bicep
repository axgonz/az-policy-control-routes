targetScope = 'tenant'

param managementGroupName string = 'policy_definitions'

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' existing = {
  name: managementGroupName
}

module allowed_locations 'definitions/allowed_locations.bicep' = {
  name: 'allowed_locations'
  scope: managementGroup
}
module subnet_has_associated_nsg 'definitions/subnet_has_associated_nsg.bicep' = {
  name: 'subnet_has_associated_nsg'
  scope: managementGroup
}
module subnet_has_associated_udr 'definitions/subnet_has_associated_udr.bicep' = {
  name: 'subnet_has_associated_udr'
  scope: managementGroup
}
module udr_has_bgp_propagation_disabled 'definitions/udr_has_bgp_propagation_disabled.bicep' = {
  name: 'udr_has_bgp_propagation_disabled'
  scope: managementGroup
}
module udr_has_default_route 'definitions/udr_has_default_route.bicep' = {
  name: 'udr_has_default_route'
  scope: managementGroup
}
module udr_has_only_one_route 'definitions/udr_has_only_one_route.bicep' = {
  name: 'udr_has_only_one_route'
  scope: managementGroup
}

module control_vnet_egress 'initiatives/control_vnet_egress.bicep' = {
  name: 'control_vnet_egress'
  scope: managementGroup
  params: {
    managementGroupName: managementGroupName
  }
  dependsOn: [
    subnet_has_associated_udr
    udr_has_bgp_propagation_disabled
    udr_has_default_route
    udr_has_only_one_route
  ]
}
