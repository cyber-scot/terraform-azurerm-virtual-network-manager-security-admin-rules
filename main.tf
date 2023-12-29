resource "azurerm_network_manager_admin_rule_collection" "rule_collections" {
  count                           = var.create_rule_collection == true ? 1 : 0
  name                            = var.rule_collection_name
  security_admin_configuration_id = var.security_admin_config_id
  network_group_ids               = var.network_group_ids
  description                     = var.rule_collection_description
}

resource "azurerm_network_manager_admin_rule" "rules" {
  for_each                 = { for k, v in var.security_admin_rules : k => v }
  name                     = each.value.name
  admin_rule_collection_id = var.create_rule_collection == true ? azurerm_network_manager_admin_rule_collection.rule_collections[0].id : each.value.admin_rule_collection_id
  action                   = each.value.action
  direction                = each.value.direction
  priority                 = each.value.priority
  protocol                 = each.value.protocol
  source_port_ranges       = each.value.source_port_ranges
  destination_port_ranges  = each.value.destination_port_ranges
  description              = each.value.description

  dynamic "source" {
    for_each = each.value.source
    content {
      address_prefix      = source.value.address_prefix
      address_prefix_type = source.value.address_prefix_type
    }
  }

  dynamic "destination" {
    for_each = each.value.destination
    content {
      address_prefix      = destination.value.address_prefix
      address_prefix_type = destination.value.address_prefix_type
    }
  }
}


resource "azurerm_network_manager_deployment" "deploy_rules" {

  depends_on = [
    azurerm_network_manager_admin_rule.rules
  ]

  count              = var.create_deployment == true ? 1 : 0
  network_manager_id = var.vnet_manager_id
  location           = var.vnet_manager_location
  scope_access       = var.deployment_type
  configuration_ids  = var.deployment_configuration_ids != null ? var.deployment_configuration_ids : [var.security_admin_config_id]
}
