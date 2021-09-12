# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "sd-ne-aro-dev-vnet01"
  resource_group_name = azurerm_resource_group.aro-poc-rg.name
  location            = azurerm_resource_group.aro-poc-rg.location
  #address_space      = ["172.17.210.0/24"]
  address_space       = ["10.0.0.0/22"]
  
  tags = {
    owner        = var.owner  
    project      = var.project
    description  = var.description
  }

}
