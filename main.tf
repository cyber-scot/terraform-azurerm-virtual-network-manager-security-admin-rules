resource "azurerm_network_manager_connectivity_configuration" "connectivity_config" {
  for_each                        = { for k, v in var.connectivity_config : k => v }
  name                            = each.value.name
  network_manager_id              = each.value.vnet_manager_id
  connectivity_topology           = each.value.connectivity_topology
  delete_existing_peering_enabled = each.value.delete_existing_peering_enabled
  global_mesh_enabled             = each.value.global_mesh_enabled
  description                     = each.value.description

  dynamic "applies_to_group" {
    for_each = each.value.applies_to_group
    content {
      group_connectivity  = applies_to_group.value.group_connectivity
      network_group_id    = applies_to_group.value.network_group_id
      global_mesh_enabled = applies_to_group.value.global_mesh_enabled
      use_hub_gateway     = applies_to_group.value.use_hub_gateway
    }
  }

  dynamic "hub" {
    for_each = each.value.hub
    content {
      resource_id   = hub.value.resource_id
      resource_type = hub.value.resource_type
    }
  }
}


resource "azurerm_network_manager_security_admin_configuration" "sec_configs" {
  for_each                                      = { for k, v in var.security_admin_config : k => v }
  name                                          = each.value.name
  network_manager_id                            = each.value.vnet_manager_id
  description                                   = each.value.description
  apply_on_network_intent_policy_based_services = each.value.apply_on_network_intent_policy_based_services
}
