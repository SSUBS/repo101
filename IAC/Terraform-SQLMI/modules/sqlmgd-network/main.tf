#
resource "azurerm_virtual_network" "sqlvnet" {
  name                  = var.sql_vnet_name
  resource_group_name   = var.resource_group_name
  location              = var.location
  address_space         = [var.sql_vnet_address]

  tags = {
    owner               = var.owner  
    project             = var.project
    description         = var.description
  }

}

#
resource "azurerm_subnet" "sqlsubnetmgdb01" {
  name                    = var.mgdb_subnet_name
  resource_group_name     = var.resource_group_name
  virtual_network_name    = azurerm_virtual_network.sqlvnet.name
  address_prefixes        = [var.mgdb_subnet_address]
  service_endpoints       = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

#
resource "azurerm_subnet" "swwebdel01" {
  name                    = var.swwebdel01_subnet_name
  resource_group_name     = var.resource_group_name
  virtual_network_name    = azurerm_virtual_network.sqlvnet.name
  address_prefixes        = [var.swwebdel01_subnet_address]
  service_endpoints       = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]

    delegation {
    name = "accountdelegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "swwebdel02" {
  name                    = var.swwebdel02_subnet_name
  resource_group_name     = var.resource_group_name
  virtual_network_name    = azurerm_virtual_network.sqlvnet.name
  address_prefixes        = [var.swwebdel02_subnet_address]
  service_endpoints       = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]

    delegation {
    name = "accountdelegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

