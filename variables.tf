variable "connectivity_config" {
  description = "A list of connectivity configuration"
  type = list(object({
    name                            = optional(string)
    connectivity_topology           = optional(string)
    vnet_manager_id                 = optional(string)
    description                     = optional(string)
    delete_existing_peering_enabled = optional(bool)
    global_mesh_enabled             = optional(bool)
    applies_to_group = optional(list(object({
      group_connectivity  = optional(string)
      network_group_id    = optional(string)
      global_mesh_enabled = optional(bool)
      use_hub_gateway     = optional(bool)
    })))
    hub = optional(list(object({
      resource_id   = optional(string)
      resource_type = optional(string, "Microsoft.Network/virtualNetworks")
    })))
  }))
}

variable "security_admin_config" {
  description = "A list of security admin configuration"
  type = list(object({
    name                                          = optional(string)
    vnet_manager_id                               = optional(string)
    description                                   = optional(string)
    apply_on_network_intent_policy_based_services = optional(list(string))
  }))
}
