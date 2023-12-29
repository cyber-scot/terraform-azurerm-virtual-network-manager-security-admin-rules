output "admin_rule_collection_description" {
  description = "The description of the Network Manager Admin Rule Collection"
  value       = var.create_rule_collection ? azurerm_network_manager_admin_rule_collection.rule_collections[0].description : null
}

output "admin_rule_collection_id" {
  description = "The ID of the Network Manager Admin Rule Collection"
  value       = var.create_rule_collection ? azurerm_network_manager_admin_rule_collection.rule_collections[0].id : null
}

output "admin_rules" {
  description = "Details of the Network Manager Admin Rules"
  value = [for rule in azurerm_network_manager_admin_rule.rules : {
    name                    = rule.name
    action                  = rule.action
    direction               = rule.direction
    priority                = rule.priority
    protocol                = rule.protocol
    source_port_ranges      = rule.source_port_ranges
    destination_port_ranges = rule.destination_port_ranges
    description             = rule.description
  }]
}

output "network_manager_deployment_configuration_ids" {
  description = "The configuration IDs used in the Network Manager Deployment"
  value       = var.create_deployment ? azurerm_network_manager_deployment.deploy_rules[0].configuration_ids : null
}

output "network_manager_deployment_id" {
  description = "The ID of the Network Manager Deployment"
  value       = var.create_deployment ? azurerm_network_manager_deployment.deploy_rules[0].id : null
}

output "network_manager_deployment_location" {
  description = "The location of the Network Manager Deployment"
  value       = var.create_deployment ? azurerm_network_manager_deployment.deploy_rules[0].location : null
}
