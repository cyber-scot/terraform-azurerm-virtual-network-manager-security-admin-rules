output "connectivity_config_ids" {
  description = "A map of connectivity configuration names to their respective IDs."
  value       = { for config in azurerm_network_manager_connectivity_configuration.connectivity_config : config.name => config.id }
}

output "connectivity_topologies" {
  description = "A map of connectivity configuration names to their connectivity topologies."
  value       = { for config in azurerm_network_manager_connectivity_configuration.connectivity_config : config.name => config.connectivity_topology }
}

output "connectivity_config_applied_groups" {
  description = "Details of groups each connectivity configuration is applied to."
  value = { for config in azurerm_network_manager_connectivity_configuration.connectivity_config :
    config.name => [for group in config.applies_to_group : {
      group_connectivity  = group.group_connectivity
      network_group_id    = group.network_group_id
      global_mesh_enabled = group.global_mesh_enabled
      use_hub_gateway     = group.use_hub_gateway
    }]
  }
}

output "security_admin_config_ids" {
  description = "A map of security admin configuration names to their respective IDs."
  value       = { for config in azurerm_network_manager_security_admin_configuration.sec_configs : config.name => config.id }
}

output "security_admin_config_descriptions" {
  description = "A map of security admin configuration names to their descriptions."
  value       = { for config in azurerm_network_manager_security_admin_configuration.sec_configs : config.name => config.description }
}

output "security_admin_config_apply_on_policy_services" {
  description = "Details of the apply_on_network_intent_policy_based_services setting for each security admin configuration."
  value = { for config in azurerm_network_manager_security_admin_configuration.sec_configs :
    config.name => config.apply_on_network_intent_policy_based_services
  }
}

