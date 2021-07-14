###########################
## Azure Provider - Main ##
###########################

# Configure the Azure provider
provider "azurerm" {
          features {}
}

data "azurerm_client_config" current{}

# Backend to store Terraform state file
#terraform {
#  backend "azurerm"{
#    resource_group_name  = "sd-ne-burst-dev-rgweb"
#    storage_account_name = "sdneburstdevsatfstate"
#    container_name       = "aks-poc-terraformstate"
#    key                  = "tfstate"
#  }
#}
