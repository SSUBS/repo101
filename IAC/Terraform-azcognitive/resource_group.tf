# Create Azure Resource group 

resource "azurerm_resource_group" "example" {
  name     = "${var.azure_resource_group_name}"
  location = "${var.azure_resource_group_location}"
}

