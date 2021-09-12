# Cluster Resource Group

resource "azurerm_resource_group" "test_rgdb" {
  name     = var.resource_group_name
  location = var.location
}

# Network
module "sqlmi_network" {
  source                      = "../modules/sqlmgd-network"
  sql_vnet_name               = var.sql_vnet_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sql_vnet_address            = var.sql_vnet_address
  mgdb_subnet_name            = var.subnet_sql01
  mgdb_subnet_address         = var.subnet_address_sql01
  swwebdel01_subnet_name      = var.subnet_swwebdel01
  swwebdel01_subnet_address   = var.subnet_address_swwebdel01
  swwebdel02_subnet_name      = var.subnet_swwebdel02
  swwebdel02_subnet_address   = var.subnet_address_swwebdel02
}

# Network Security Group (NSG)
resource "azurerm_template_deployment" "test_nsg" {
  name                          = "nsg-sd-ne-burst-test-sqlmgd01"
  resource_group_name           = var.resource_group_name

  template_body = file("../modules/sqlmgd-nsg-arm/nsg.json")

  deployment_mode = "Incremental"

  depends_on = [
    azurerm_subnet.sqlsubnetmgdb01,
    azurerm_subnet.swwebdel01,
    azurerm_subnet.swwebdel02
  ]
}

#  user-defined route table (UDR) 
resource "azurerm_template_deployment" "test_udr" {
  name                          = "sd-ne-aro-dev-aro01"
  resource_group_name           = var.resource_group_name

  template_body = file("../modules/sqlmgd-nsg-arm/udr.json")
  
  deployment_mode = "Incremental"

  depends_on = [
    azurerm_subnet.sqlsubnetmgdb01,
    azurerm_subnet.swwebdel01,
    azurerm_subnet.swwebdel02
  ]
}



# SQL managed instance 
resource "azurerm_template_deployment" "test_sqlmi" {
  name                          = "sd-ne-aro-dev-aro01"
  resource_group_name           = var.resource_group_name

  template_body = file("../modules/sqlmgd-mi-arm/sqlmi.json")
  
  deployment_mode = "Incremental"

  depends_on = [
    azurerm_subnet.sqlsubnetmgdb01,
    azurerm_subnet.swwebdel01,
    azurerm_subnet.swwebdel02
  ]
}






