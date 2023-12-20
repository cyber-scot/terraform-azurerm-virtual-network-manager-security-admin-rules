```hcl
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
| [azurerm_network_manager.avnm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager) | resource |
| [azurerm_network_manager_connectivity_configuration.connectivity_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_connectivity_configuration) | resource |
| [azurerm_network_manager_network_group.groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_network_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connectivity_config"></a> [connectivity\_config](#input\_connectivity\_config) | A list of connectivity configuration | <pre>list(object({<br>    name                  = optional(string)<br>    connectivity_topology = optional(string)<br>    applies_to_group = optional(list(object({<br>      group_connectivity  = optional(string)<br>      network_group_id    = optional(string)<br>      global_mesh_enabled = optional(bool)<br>    })))<br>    hub = optional(list(object({<br>      resource_id   = optional(string)<br>      resource_type = optional(string, "Microsoft.Network/virtualNetworks")<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | The description attached to AVNM | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location where resources will be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the AVNM instance | `string` | n/a | yes |
| <a name="input_network_groups"></a> [network\_groups](#input\_network\_groups) | A set of network groups to be made inside AVNM | `set(string)` | `[]` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope block in to which AVNM is deployed | <pre>list(object({<br>    management_group_ids = optional(list(string))<br>    subscription_ids     = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_scope_accesses"></a> [scope\_accesses](#input\_scope\_accesses) | A list of configuration types | `list(string)` | <pre>[<br>  "Connectivity",<br>  "SecurityAdmin"<br>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

No outputs.
