```hcl
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
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_manager_connectivity_configuration.connectivity_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_connectivity_configuration) | resource |
| [azurerm_network_manager_security_admin_configuration.sec_configs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_security_admin_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connectivity_config"></a> [connectivity\_config](#input\_connectivity\_config) | A list of connectivity configuration | <pre>list(object({<br>    name                            = optional(string)<br>    connectivity_topology           = optional(string)<br>    vnet_manager_id                 = optional(string)<br>    description                     = optional(string)<br>    delete_existing_peering_enabled = optional(bool)<br>    global_mesh_enabled             = optional(bool)<br>    applies_to_group = optional(list(object({<br>      group_connectivity  = optional(string)<br>      network_group_id    = optional(string)<br>      global_mesh_enabled = optional(bool)<br>      use_hub_gateway     = optional(bool)<br>    })))<br>    hub = optional(list(object({<br>      resource_id   = optional(string)<br>      resource_type = optional(string, "Microsoft.Network/virtualNetworks")<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_security_admin_config"></a> [security\_admin\_config](#input\_security\_admin\_config) | A list of security admin configuration | <pre>list(object({<br>    name                                          = optional(string)<br>    vnet_manager_id                               = optional(string)<br>    delete_existing_peering_enabled               = optional(bool)<br>    description                                   = optional(string)<br>    apply_on_network_intent_policy_based_services = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connectivity_config_applied_groups"></a> [connectivity\_config\_applied\_groups](#output\_connectivity\_config\_applied\_groups) | Details of groups each connectivity configuration is applied to. |
| <a name="output_connectivity_config_ids"></a> [connectivity\_config\_ids](#output\_connectivity\_config\_ids) | A map of connectivity configuration names to their respective IDs. |
| <a name="output_connectivity_topologies"></a> [connectivity\_topologies](#output\_connectivity\_topologies) | A map of connectivity configuration names to their connectivity topologies. |
| <a name="output_security_admin_config_apply_on_policy_services"></a> [security\_admin\_config\_apply\_on\_policy\_services](#output\_security\_admin\_config\_apply\_on\_policy\_services) | Details of the apply\_on\_network\_intent\_policy\_based\_services setting for each security admin configuration. |
| <a name="output_security_admin_config_descriptions"></a> [security\_admin\_config\_descriptions](#output\_security\_admin\_config\_descriptions) | A map of security admin configuration names to their descriptions. |
| <a name="output_security_admin_config_ids"></a> [security\_admin\_config\_ids](#output\_security\_admin\_config\_ids) | A map of security admin configuration names to their respective IDs. |
