targetScope = 'tenant'

var config = loadJsonContent('../config.json')
var managementGroupName = config.managementGroupName
var assign = config.policy.deployAssignments

resource managementGroup 'Microsoft.Management/managementGroups@2023-04-01' existing = {
  name: managementGroupName
}

// Deploy definitions (udr)
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
// module udr_has_only_one_route 'definitions/udr_has_only_one_route.bicep' = {
//   name: 'udr_has_only_one_route'
//   scope: managementGroup
// }
// module udr_has_resource_lock 'definitions/udr_has_resource_lock.bicep' = {
//   name: 'udr_has_resource_lock'
//   scope: managementGroup
// }

// Deploy definitions (nsg)
module subnet_has_associated_nsg 'definitions/subnet_has_associated_nsg.bicep' = {
  name: 'subnet_has_associated_nsg'
  scope: managementGroup
}
module nsg_not_allows_public_inbound 'definitions/nsg_not_allows_public_inbound.bicep' = {
  name: 'nsg_not_allows_public_inbound'
  scope: managementGroup
}
module nsgrule_not_allows_public_inbound 'definitions/nsgrule_not_allows_public_inbound.bicep' = {
  name: 'nsgrule_not_allows_public_inbound'
  scope: managementGroup
}

// module nsg_not_allows_any_inbound 'definitions/nsg_not_allows_any_inbound.bicep' = {
//   name: 'nsg_not_allows_any_inbound'
//   scope: managementGroup
// }
// module nsg_not_allows_internet_inbound 'definitions/nsg_not_allows_internet_inbound.bicep' = {
//   name: 'nsg_not_allows_internet_inbound'
//   scope: managementGroup
// }
// module nsg_not_allows_non_rfc1918_a_inbound 'definitions/nsg_not_allows_non_rfc1918_a_inbound.bicep' = {
//   name: 'nsg_not_allows_non_rfc1918_a_inbound'
//   scope: managementGroup
// }
// module nsg_not_allows_non_rfc1918_b_inbound 'definitions/nsg_not_allows_non_rfc1918_b_inbound.bicep' = {
//   name: 'nsg_not_allows_non_rfc1918_b_inbound'
//   scope: managementGroup
// }
// module nsg_not_allows_non_rfc1918_c_inbound 'definitions/nsg_not_allows_non_rfc1918_c_inbound.bicep' = {
//   name: 'nsg_not_allows_non_rfc1918_c_inbound'
//   scope: managementGroup
// }
// module subscription_has_policy_controlled_nsg 'deployments/subscription_has_policy_controlled_nsg.bicep' = {
//   name: 'subscription_has_policy_controlled_nsg'
//   scope: managementGroup
// }

// Deploy initiatives
module audit_vnet_egress_controls 'initiatives/audit_vnet_egress_controls.bicep' = {
  name: 'audit_vnet_egress_controls'
  scope: managementGroup
  dependsOn: [
    subnet_has_associated_udr
    udr_forces_next_hop
  ]
}
module audit_vnet_ingress_controls 'initiatives/audit_vnet_ingress_controls.bicep' = {
  name: 'audit_vnet_ingress_controls'
  scope: managementGroup
  dependsOn: [
    subnet_has_associated_nsg
    nsg_not_allows_public_inbound
  ]
}
module control_vnet_egress 'initiatives/control_vnet_egress.bicep' = {
  name: 'control_vnet_egress'
  scope: managementGroup
  dependsOn: [
    subnet_is_associated_with_desired_udr
    udr_has_bgp_propagation_disabled
    udr_has_default_route
  ]
}
module control_vnet_ingress 'initiatives/control_vnet_ingress.bicep' = {
  name: 'control_vnet_ingress'
  scope: managementGroup
  dependsOn: [
    subnet_has_associated_nsg
    nsgrule_not_allows_public_inbound
  ]
}

// Deploy assignments
module audit_vnet_egress_controls_assignment 'assignments/audit_vnet_egress_controls.bicep' = if (assign) {
  name: 'audit_vnet_egress_controls_assignment'
  scope: managementGroup
  dependsOn: [
    audit_vnet_egress_controls
  ]
}
module audit_vnet_ingress_controls_assignment 'assignments/audit_vnet_ingress_controls.bicep' = if (assign) {
  name: 'audit_vnet_ingress_controls_assignment'
  scope: managementGroup
  dependsOn: [
    audit_vnet_ingress_controls
  ]
}
module control_vnet_egress_assignment 'assignments/control_vnet_egress.bicep' = if (assign) {
  name: 'control_vnet_egress_assignment'
  scope: managementGroup
  dependsOn: [
    control_vnet_egress
  ]
}
module control_vnet_ingress_assignment 'assignments/control_vnet_ingress.bicep' = if (assign) {
  name: 'control_vnet_ingress_assignment'
  scope: managementGroup
  dependsOn: [
    control_vnet_ingress
  ]
}

