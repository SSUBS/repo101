#subnets

# Create subnet for master nodes
resource "azurerm_subnet" "master-subnet" {
  name                                          = "sd-ne-aro-dev-vn01-sn01"
  resource_group_name                           = azurerm_resource_group.aro-poc-rg.name
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  #address_prefixes                              = ["172.17.210.0/25"]
  address_prefixes                              = ["10.0.0.0/23"]
  service_endpoints                             = ["Microsoft.ContainerRegistry"]
  enforce_private_link_service_network_policies = true

  delegation {
    name = "accountdelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
#
# Create subnet for worker nodes
resource "azurerm_subnet" "worker-subnet" {
  name                           = "sd-ne-aro-dev-vn01-sn02"
  resource_group_name            = azurerm_resource_group.aro-poc-rg.name
  virtual_network_name           = azurerm_virtual_network.vnet.name
  #address_prefixes               = ["172.17.210.128/25"]
  address_prefixes               = ["10.0.2.0/23"]
  service_endpoints              = ["Microsoft.ContainerRegistry"]

  delegation {
    name = "accountdelegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}
