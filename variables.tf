variable "create_deployment" {
  type        = bool
  description = "Whether the module should attempt a deployment"
  default     = false
}

variable "create_rule_collection" {
  type        = bool
  description = "Whether a rule collection should be made"
  default     = true
}

variable "deployment_configuration_ids" {
  type        = list(string)
  description = "A list of VNet manager configurations"
  default     = []
}

variable "deployment_type" {
  type        = string
  description = "The deployment type if deployment is used"
  default     = null
}

variable "network_group_ids" {
  type        = list(string)
  description = "A list of network groups the rules apply to"
  default     = []
}

variable "rule_collection_description" {
  type        = string
  description = "The description of the rule collection"
  default     = null
}

variable "rule_collection_name" {
  type        = string
  description = "The name of the rule collection"
  default     = null
}

variable "security_admin_config_id" {
  type        = string
  description = "The id of the security admin config"
  default     = null
}

variable "security_admin_rules" {
  description = "A list of security admin rules for network manager"
  type = list(object({
    name                     = string
    action                   = string
    admin_rule_collection_id = optional(string)
    direction                = string
    priority                 = number
    protocol                 = string
    source_port_ranges       = optional(list(string))
    destination_port_ranges  = optional(list(string))
    description              = optional(string)

    source = optional(list(object({
      address_prefix      = string
      address_prefix_type = string
    })))
    destination = optional(list(object({
      address_prefix      = string
      address_prefix_type = string
    })))
  }))
}

variable "vnet_manager_id" {
  type        = string
  description = "The id of the vnet manager"
  default     = null
}

variable "vnet_manager_location" {
  type        = string
  description = "The location the vnet manager is in"
  default     = null
}
