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
    name                            = optional(string)
    vnet_manager_id                 = optional(string)
    delete_existing_peering_enabled = optional(bool)
    description                     = optional(string)
    apply_on_network_intent_policy_based_services = optional(list(string))
  }))
}


#variable "location" {
#  description = "The location where resources will be created."
#  type        = string
#}
#
#variable "name" {
#  type        = string
#  description = "The name of the AVNM instance"
#}
#
#variable "rg_name" {
#  description = "The name of the resource group."
#  type        = string
#}
#
#variable "tags" {
#  description = "A map of tags to add to all resources."
#  type        = map(string)
#  default     = {}
#}
