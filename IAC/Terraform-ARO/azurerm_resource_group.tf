# Create Resource Group
resource "azurerm_resource_group" "aro-poc-rg" {
#  name     = "${var.company}-${var.region}-${var.environment}-rgaro"
   name     = "sd-ne-aro-dev-rgall"
   location = var.location
    
  tags = {
    owner        = var.owner  
    project      = var.project
    description  = var.description
  }
}
