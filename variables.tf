variable "connectivity_config" {
  description = "A list of connectivity configuration"
  type = list(object({
    name                  = optional(string)
    connectivity_topology = optional(string)
    applies_to_group = optional(list(object({
      group_connectivity  = optional(string)
      network_group_id    = optional(string)
      global_mesh_enabled = optional(bool)
    })))
    hub = optional(list(object({
      resource_id   = optional(string)
      resource_type = optional(string, "Microsoft.Network/virtualNetworks")
    })))
  }))
}

variable "description" {
  description = "The description attached to AVNM"
  type        = string
  default     = null
}

variable "location" {
  description = "The location where resources will be created."
  type        = string
}

variable "name" {
  type        = string
  description = "The name of the AVNM instance"
}

variable "network_groups" {
  description = "A set of network groups to be made inside AVNM"
  type        = set(string)
  default     = []
}

variable "rg_name" {
  description = "The name of the resource group."
  type        = string
}

variable "scope" {
  description = "The scope block in to which AVNM is deployed"
  type = list(object({
    management_group_ids = optional(list(string))
    subscription_ids     = optional(list(string))
  }))
}

variable "scope_accesses" {
  description = "A list of configuration types"
  type        = list(string)
  default     = ["Connectivity", "SecurityAdmin"]
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
