```hcl
module "rg" {
  source = "cyber-scot/rg/azurerm"

  name     = "rg-${var.short}-${var.loc}-${var.env}-01"
  location = local.location
  tags     = local.tags
}

data "azurerm_subscription" "current" {}

module "vnet_manager" {
  source = "cyber-scot/virtual-network-manager/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags


  name = "avnm-${var.short}-${var.loc}-${var.env}-01"

  scope = [
    {
      subscription_ids = [data.azurerm_subscription.current.id]
    }
  ]

  scope_accesses = [
    "Connectivity",
    "SecurityAdmin"
  ]

  network_groups = [
    "Prd",
    "Dev"
  ]
}

module "hub_network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-hub-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "sn1-${module.hub_network.vnet_name}" = {
      address_prefixes  = ["10.0.0.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

module "hub_nsg" {
  source = "cyber-scot/nsg/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  nsg_name              = "nsg-hub-${var.short}-${var.loc}-${var.env}-01"
  associate_with_subnet = true
  subnet_id             = element(values(module.hub_network.subnets_ids), 0)
  custom_nsg_rules = {
    "AllowVnetInbound" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }
}

module "spoke_network" {
  source = "cyber-scot/network/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  vnet_name          = "vnet-spoke-${var.short}-${var.loc}-${var.env}-01"
  vnet_location      = module.rg.rg_location
  vnet_address_space = ["10.0.0.0/16"]

  subnets = {
    "sn1-${module.spoke_network.vnet_name}" = {
      address_prefixes  = ["10.0.0.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

module "spoke_nsg" {
  source = "cyber-scot/nsg/azurerm"

  rg_name  = module.rg.rg_name
  location = module.rg.rg_location
  tags     = module.rg.rg_tags

  nsg_name              = "nsg-spoke-${var.short}-${var.loc}-${var.env}-01"
  associate_with_subnet = true
  subnet_id             = element(values(module.spoke_network.subnets_ids), 0)
  custom_nsg_rules = {
    "AllowVnetInbound" = {
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }
}


module "vnet_manager_config" {
  source = "cyber-scot/virtual-network-manager-configuration/azurerm"

  connectivity_config = [
    {
      name                            = "Config1"
      vnet_manager_id                 = module.vnet_manager.network_manager_id
      connectivity_topology           = "HubAndSpoke"
      delete_existing_peering_enabled = true
      global_mesh_enabled             = false
      applies_to_group = [
        {
          group_connectivity  = "DirectlyConnected"
          network_group_id    = module.vnet_manager.network_group_ids["Prd"]
          global_mesh_enabled = false
          use_hub_gateway     = true
        }
      ]
      hub = [
        {
          resource_id = module.hub_network.vnet_id
        }
      ]
    }
  ]

  security_admin_config = [
    {
      name                                          = "SecConfig1"
      vnet_manager_id                               = module.vnet_manager.network_manager_id
      apply_on_network_intent_policy_based_services = ["None"]
      description                                   = "Sec config 1"
    }
  ]
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.85.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.2 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub_network"></a> [hub\_network](#module\_hub\_network) | cyber-scot/network/azurerm | n/a |
| <a name="module_hub_nsg"></a> [hub\_nsg](#module\_hub\_nsg) | cyber-scot/nsg/azurerm | n/a |
| <a name="module_rg"></a> [rg](#module\_rg) | cyber-scot/rg/azurerm | n/a |
| <a name="module_spoke_network"></a> [spoke\_network](#module\_spoke\_network) | cyber-scot/network/azurerm | n/a |
| <a name="module_spoke_nsg"></a> [spoke\_nsg](#module\_spoke\_nsg) | cyber-scot/nsg/azurerm | n/a |
| <a name="module_vnet_manager"></a> [vnet\_manager](#module\_vnet\_manager) | cyber-scot/virtual-network-manager/azurerm | n/a |
| <a name="module_vnet_manager_config"></a> [vnet\_manager\_config](#module\_vnet\_manager\_config) | cyber-scot/virtual-network-manager-configuration/azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [external_external.detect_os](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.generate_timestamp](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.client_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Regions"></a> [Regions](#input\_Regions) | Converts shorthand name to longhand name via lookup on map list | `map(string)` | <pre>{<br>  "eus": "East US",<br>  "euw": "West Europe",<br>  "uks": "UK South",<br>  "ukw": "UK West"<br>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | The env variable, for example - prd for production. normally passed via TF\_VAR. | `string` | `"prd"` | no |
| <a name="input_loc"></a> [loc](#input\_loc) | The loc variable, for the shorthand location, e.g. uks for UK South.  Normally passed via TF\_VAR. | `string` | `"uks"` | no |
| <a name="input_short"></a> [short](#input\_short) | The shorthand name of to be used in the build, e.g. cscot for CyberScot.  Normally passed via TF\_VAR. | `string` | `"cscot"` | no |
| <a name="input_static_tags"></a> [static\_tags](#input\_static\_tags) | The tags variable | `map(string)` | <pre>{<br>  "Contact": "info@cyber.scot",<br>  "CostCentre": "671888",<br>  "ManagedBy": "Terraform"<br>}</pre> | no |

## Outputs

No outputs.
