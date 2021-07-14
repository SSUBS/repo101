provider "azurerm" {
    skip_provider_registration = true
    features {}
}
 
terraform {
  backend "azurerm" {}
}

# Reference client config
data "azurerm_client_config" "current" {}

## Resource groups
resource "azurerm_resource_group" "web_resource_group" {
  name     = "${var.company}-${var.region}-${var.project}-${var.environment}-rgweb"
  location = var.location
}

resource "azurerm_resource_group" "web_windows" {
  name     = "${var.company}-${var.region}-${var.project}-${var.environment}-rgweb-win"
  location = var.location
}

resource "azurerm_resource_group" "data_resource_group" {
  name     = "${var.company}-${var.region}-${var.project}-${var.environment}-rgdb"
  location = var.location
}

resource "azurerm_application_insights" "web" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-aiweb"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_resource_group.name
  application_type    = "web"
}

# Create storage account 
resource "azurerm_storage_account" "web-sa" {
  name                     = "${var.company}${var.region}${var.project}${var.environment}saweb"
  resource_group_name      = azurerm_resource_group.web_resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create config storage container
resource "azurerm_storage_container" "web-config" {
  name                 = "config"
  storage_account_name = azurerm_storage_account.web-sa.name
}

# Vnet 
resource "azurerm_virtual_network" "web-vnet" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-vnweb01"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_resource_group.name
  address_space       = ["172.17.220.0/24"]
}

# SubNet 01
resource "azurerm_subnet" "web-snet1" {
  name                                            = "${var.company}-${var.region}-${var.project}-${var.environment}-snweb01"
  virtual_network_name                            = azurerm_virtual_network.web-vnet.name
  resource_group_name                             = azurerm_resource_group.web_resource_group.name
  address_prefixes                                = ["172.17.220.0/26"]
  enforce_private_link_endpoint_network_policies  = true
  enforce_private_link_service_network_policies   = true

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

# SubNet 02 
resource "azurerm_subnet" "web-snet2" {
  name                                            = "${var.company}-${var.region}-${var.project}-${var.environment}-snweb02"
  virtual_network_name                            = azurerm_virtual_network.web-vnet.name
  resource_group_name                             = azurerm_resource_group.web_resource_group.name
  address_prefixes                                = ["172.17.220.128/25"]
  enforce_private_link_endpoint_network_policies  = true
  enforce_private_link_service_network_policies   = true
  
}

#SubNet 03
resource "azurerm_subnet" "web-win" {
  name                                            = "${var.company}-${var.region}-${var.project}-${var.environment}-snweb03"
  virtual_network_name                            = azurerm_virtual_network.web-vnet.name
  resource_group_name                             = azurerm_resource_group.web_resource_group.name
  address_prefixes                                = ["172.17.220.64/26"]
  enforce_private_link_endpoint_network_policies  = true
  enforce_private_link_service_network_policies   = true

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}

# Network Profile
resource "azurerm_network_profile" "web-netp" {
  name                = "${var.company}${var.region}${var.project}${var.environment}npweb01"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_resource_group.name

  container_network_interface {
    name = "cninic"

    ip_configuration {
      name      = "cnipconfig"
      subnet_id = azurerm_subnet.web-snet1.id
    }
  }
}


# Key Vault
resource "azurerm_key_vault" "key_vault" {
  location            = var.location
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-kv01"
  resource_group_name = azurerm_resource_group.web_resource_group.name
  
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  tenant_id                  = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault_access_policy" "build_agent_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  
  secret_permissions = [
    "get",
    "list",
    "set",
  ]
}

# Redis cache
# resource "azurerm_redis_cache" "redis_cluster" {
#   location            = var.location
#   name                = "${var.company}-${var.region}-${var.project}-${var.environment}-rd01"
#   resource_group_name = azurerm_resource_group.data_resource_group.name

#   capacity                      = 1
#   enable_non_ssl_port           = false
#   family                        = "P"
#   public_network_access_enabled = false
#   shard_count                   = 2
#   sku_name                      = "Premium"
#   subnet_id                     = azurerm_subnet.web-snet2.id
#   redis_configuration {
#     maxmemory_policy = "volatile-lru"
#   }
# }

resource "azurerm_redis_cache" "redis_cluster" {
  location            = var.location
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-rd01"
  resource_group_name = azurerm_resource_group.data_resource_group.name

  capacity                      = 0
  enable_non_ssl_port           = false
  family                        = "C"
  sku_name                      = "Basic"
  redis_configuration {
    maxmemory_policy = "volatile-lru"
  }
}

# Save the connection strings to Key Vault
resource "azurerm_key_vault_secret" "redis_connections" {
  for_each = toset([
    "CacheConfig--RedisLocalConnectionString",
    "CacheConfig--RedisLocalQueryConnectionString",
    "CacheConfig--RedisOnlyConnectionString",
    "CacheConfig--RedisOnlyQueryConnectionString",
    "CacheConfig--RedisOutputConnectionString",
    "CacheConfig--RedisOutputQueryConnectionString",
    "DataProtection--RedisConnectionString",
    "RedisPromo--ConnectionString"
  ])

  key_vault_id = azurerm_key_vault.key_vault.id
  name         = each.key
  value        = azurerm_redis_cache.redis_cluster.primary_connection_string
}

# Create app service plan
resource "azurerm_app_service_plan" "linux-asp" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-asp-linux"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_resource_group.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "PremiumV2"
    size = "P3v2"
  }
}

module "waapigateway" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-waapigateway"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "api-gateway:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "waidentityserver" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-waidentityserver"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "identity-server:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wamenuapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wamenuapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "menu-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "waproductapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-waproductapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "product-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wabasketapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wabasketapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "basket-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wacheckoutapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wacheckoutapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "checkout-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wadeliveryapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wadeliveryapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "delivery-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "waprofileapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-waprofileapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "profile-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wastoreapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wastoreapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "store-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "waorderhistoryapi" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-waorderhistoryapi"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "order-history-api:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
}

module "wawebsite" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wawebsite"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "website:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
  aspnetcore_environment          = "Development"
}

module "wawebsitesecure" {
  source                          = "./modules/app-service"
  name                            = "${var.company}-${var.region}-${var.project}-${var.environment}-wawebsitesecure"
  location                        = var.location
  resource_group                  = azurerm_resource_group.web_resource_group.name
  app_service_plan_id             = azurerm_app_service_plan.linux-asp.id
  docker_image_name               = "website-secure:latest"
  docker_registry_server_url      = var.docker_registry_server_url
  docker_registry_server_username = var.docker_registry_server_username
  docker_registry_server_password = var.DOCKER_REGISTRY_SERVER_PASSWORD
  storage_account_name            = azurerm_storage_account.web-sa.name
  storage_account_container_name  = "config"
  storage_account_access_key      = azurerm_storage_account.web-sa.primary_access_key
  subnet_id                       = azurerm_subnet.web-snet1.id
  key_vault_id                    = azurerm_key_vault.key_vault.id
  tenet_id                        = data.azurerm_client_config.current.tenant_id
  aspnetcore_environment          = "Development"
}


resource "azurerm_app_service_plan" "windows-asp" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-asp-windows"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_windows.name
  kind                = "Windows"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "wapaymentapi" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-wapaymentapi"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_windows.name
  app_service_plan_id = azurerm_app_service_plan.windows-asp.id
  client_cert_enabled = false
  client_affinity_enabled = true
  https_only = false

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on         = true
    dotnet_framework_version = "v4.0"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = 1
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 30
        retention_in_mb   = 35
      }
    }
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "wapaymentapi_vnet_integration" {
  app_service_id = azurerm_app_service.wapaymentapi.id
  subnet_id      = azurerm_subnet.web-win.id
}

resource "azurerm_key_vault_access_policy" "wapaymentapi_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_app_service.wapaymentapi.identity[0].principal_id
  
  secret_permissions = [
    "get",
    "list"
  ]
}



# Create image storage container - temp until image solution in place
resource "azurerm_storage_container" "web-images" {
  name                 = "images"
  storage_account_name = azurerm_storage_account.web-sa.name
}

## ARM template deployment
resource "azurerm_template_deployment" "font_door_rules_engine" {
  name                = "${var.company}-${var.region}-${var.project}-${var.environment}-frontend"
  resource_group_name = azurerm_resource_group.web_resource_group.name
  template_body       = file("./arm-templates/front-door-template.json")

  parameters = {
    "name"                  = "${var.company}-${var.region}-${var.project}-${var.environment}-frontend"
    "backend_address"       = "${var.company}-${var.region}-${var.project}-${var.environment}-waapigateway.azurewebsites.net"
    "storage_account_name"  = azurerm_storage_account.web-sa.name
  }

  deployment_mode = "Incremental"
}