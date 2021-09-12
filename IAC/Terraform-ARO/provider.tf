###########################
## Azure Provider - Main ##
###########################

# Configure the Azure provider
provider "azurerm" {
          features {}
}

#terraform {
#  backend "azurerm"{
#    resource_group_name  = "sd-ne-burst-dev-rgweb"
#    storage_account_name = "sdneburstdevsatfstate"
#    container_name       = "aro-poc-terraformstate"
#    key                  = "tfstate"
#  }
#}

data "azurerm_client_config" current{}

# Backend to store Terraform state file
#terraform {
#  backend "azurerm" {
#    resource_group_name  = "sd-ne-burst-poc-rgall"
#    storage_account_name = "sdneburstpoctfstate"
#    container_name       = "terraformstate"
#    key                  = "tfstate"
#  }
#}
