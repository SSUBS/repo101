###########################
## Azure Provider - Main ##
###########################

# Configure the Azure provider
provider "azurerm" {
          features {}
}

data "azurerm_client_config" current{}

#terraform {
#  backend "azurerm"{
#    resource_group_name  = "sd-ne-burst-dev-rgweb"
#    storage_account_name = "sdneburstdevsatfstate"
#    container_name       = "aro-poc-terraformstate"
#    key                  = "tfstate"
#  }
#}


# Backend to store Terraform state file
terraform {
  backend "azurerm" {
    resource_group_name    =  "ss-uksrg-default"
    storage_account_name   =  "ssakspoc"
    container_name         =  "akspoctfstate"
    key                    =  "tfstate"
  }
}

