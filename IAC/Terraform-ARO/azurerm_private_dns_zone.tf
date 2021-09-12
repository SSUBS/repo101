# Create a private DNS zone within the resource group
resource "azurerm_private_dns_zone" "private-dns-zone" {
  name                = "sd-aro-poc.com"
  resource_group_name = azurerm_resource_group.aro-poc-rg.name
  
  tags = {
    owner        = var.owner  
    project      = var.project
    description  = var.description
  }
  
}
