resource "azurerm_network_manager" "avnm" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  tags                = var.tags
  description         = var.description


  dynamic "scope" {
    for_each = var.scope != null ? var.scope : []
    content {
      management_group_ids = scope.value.management_group_ids
      subscription_ids     = scope.value.subscription_ids
    }
  }
  scope_accesses = var.scope_accesses
}


resource "azurerm_network_manager_network_group" "groups" {
  for_each           = toset(var.network_groups)
  name               = each.value
  network_manager_id = azurerm_network_manager.avnm.id
}

resource "azurerm_network_manager_connectivity_configuration" "connectivity_config" {
  for_each              = { for k, v in var.connectivity_config : k => v }
  name                  = each.value.name != null ? each.value.name : "${var.name}-conn-config"
  network_manager_id    = azurerm_network_manager.avnm.id
  connectivity_topology = each.value.connectivity_topology


  dynamic "applies_to_group" {
    for_each = each.value.applies_to_group
    content {
      group_connectivity  = applies_to_group.value.group_connectivity
      network_group_id    = applies_to_group.value.network_group_id
      global_mesh_enabled = applies_to_group.value.global_mesh_enabled
    }
  }

  dynamic "hub" {
    for_each = each.value.hub
    content {
      resource_id   = hub.value.hub_vnet_id
      resource_type = hub.value.resource_type
    }
  }
}
