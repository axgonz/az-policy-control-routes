targetScope = 'tenant'

param managementGroupName string = 'policy_definitions'

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' existing = {
  name: managementGroupName
}

module subnet_has_associated_udr 'definitions/subnet_has_associated_udr.bicep' = {
  name: 'subnet_has_associated_udr'
  scope: managementGroup
}
module subnet_is_associated_with_desired_udr 'definitions/subnet_is_associated_with_desired_udr.bicep' = {
  name: 'subnet_is_associated_with_desired_udr'
  scope: managementGroup
}
module udr_forces_next_hop 'definitions/udr_forces_next_hop.bicep' = {
  name: 'udr_forces_next_hop'
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

module audit__control_vnet_egress 'initiatives/audit__control_vnet_egress.bicep' = {
  name: 'audit__control_vnet_egress'
  scope: managementGroup
  params: {
    managementGroupName: managementGroupName
  }
  dependsOn: [
    subnet_has_associated_udr
    udr_forces_next_hop
  ]
}

module deny__control_vnet_egress 'initiatives/deny__control_vnet_egress.bicep' = {
  name: 'deny__control_vnet_egress'
  scope: managementGroup
  params: {
    managementGroupName: managementGroupName
  }
  dependsOn: [
    subnet_is_associated_with_desired_udr
    udr_has_bgp_propagation_disabled
    udr_has_default_route
    udr_has_only_one_route
  ]
}
