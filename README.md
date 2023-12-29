```hcl
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
  configuration_ids  = var.deployment_configuration_ids != null ? var.deployment_configuration_ids : var.security_admin_config_id
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.85.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_manager_admin_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule) | resource |
| [azurerm_network_manager_admin_rule_collection.rule_collections](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_admin_rule_collection) | resource |
| [azurerm_network_manager_deployment.deploy_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_manager_deployment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_deployment"></a> [create\_deployment](#input\_create\_deployment) | Whether the module should attempt a deployment | `bool` | `false` | no |
| <a name="input_create_rule_collection"></a> [create\_rule\_collection](#input\_create\_rule\_collection) | Whether a rule collection should be made | `bool` | `true` | no |
| <a name="input_deployment_configuration_ids"></a> [deployment\_configuration\_ids](#input\_deployment\_configuration\_ids) | A list of VNet manager configurations | `list(string)` | `[]` | no |
| <a name="input_deployment_type"></a> [deployment\_type](#input\_deployment\_type) | The deployment type if deployment is used | `string` | `null` | no |
| <a name="input_network_group_ids"></a> [network\_group\_ids](#input\_network\_group\_ids) | A list of network groups the rules apply to | `list(string)` | `[]` | no |
| <a name="input_rule_collection_description"></a> [rule\_collection\_description](#input\_rule\_collection\_description) | The description of the rule collection | `string` | `null` | no |
| <a name="input_rule_collection_name"></a> [rule\_collection\_name](#input\_rule\_collection\_name) | The name of the rule collection | `string` | `null` | no |
| <a name="input_security_admin_config_id"></a> [security\_admin\_config\_id](#input\_security\_admin\_config\_id) | The id of the security admin config | `string` | `null` | no |
| <a name="input_security_admin_rules"></a> [security\_admin\_rules](#input\_security\_admin\_rules) | A list of security admin rules for network manager | <pre>list(object({<br>    name                     = string<br>    action                   = string<br>    admin_rule_collection_id = optional(string)<br>    direction                = string<br>    priority                 = number<br>    protocol                 = string<br>    source_port_ranges       = optional(list(string))<br>    destination_port_ranges  = optional(list(string))<br>    description              = optional(string)<br><br>    source = optional(list(object({<br>      address_prefix      = string<br>      address_prefix_type = string<br>    })))<br>    destination = optional(list(object({<br>      address_prefix      = string<br>      address_prefix_type = string<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_vnet_manager_id"></a> [vnet\_manager\_id](#input\_vnet\_manager\_id) | The id of the vnet manager | `string` | `null` | no |
| <a name="input_vnet_manager_location"></a> [vnet\_manager\_location](#input\_vnet\_manager\_location) | The location the vnet manager is in | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_rule_collection_description"></a> [admin\_rule\_collection\_description](#output\_admin\_rule\_collection\_description) | The description of the Network Manager Admin Rule Collection |
| <a name="output_admin_rule_collection_id"></a> [admin\_rule\_collection\_id](#output\_admin\_rule\_collection\_id) | The ID of the Network Manager Admin Rule Collection |
| <a name="output_admin_rules"></a> [admin\_rules](#output\_admin\_rules) | Details of the Network Manager Admin Rules |
| <a name="output_network_manager_deployment_configuration_ids"></a> [network\_manager\_deployment\_configuration\_ids](#output\_network\_manager\_deployment\_configuration\_ids) | The configuration IDs used in the Network Manager Deployment |
| <a name="output_network_manager_deployment_id"></a> [network\_manager\_deployment\_id](#output\_network\_manager\_deployment\_id) | The ID of the Network Manager Deployment |
| <a name="output_network_manager_deployment_location"></a> [network\_manager\_deployment\_location](#output\_network\_manager\_deployment\_location) | The location of the Network Manager Deployment |
