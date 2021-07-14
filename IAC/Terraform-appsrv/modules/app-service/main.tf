resource "azurerm_app_service" "new_app_service" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  app_service_plan_id = var.app_service_plan_id
  client_cert_enabled = false
  client_affinity_enabled = true
  https_only = false
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on         = true
    linux_fx_version  = "DOCKER|${var.docker_registry_server_url}/${var.docker_image_name}"
  }

  storage_account {
    name = "web-config-mount"
    type = "AzureBlob"
    account_name = var.storage_account_name
    share_name = var.storage_account_container_name
    access_key = var.storage_account_access_key
    mount_path = "/home/config"
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = true
    DOCKER_CUSTOM_IMAGE_NAME            = var.docker_image_name
    DOCKER_ENABLE_CI                    = false
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.docker_registry_server_password
    DOCKER_REGISTRY_SERVER_URL          = "https://${var.docker_registry_server_url}"
    DOCKER_REGISTRY_SERVER_USERNAME     = var.docker_registry_server_username
    ASPNETCORE_ENVIRONMENT              = var.aspnetcore_environment
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

resource "azurerm_app_service_virtual_network_swift_connection" "new_app_service_vnet_integration" {
  app_service_id = azurerm_app_service.new_app_service.id
  subnet_id      = var.subnet_id
}


resource "azurerm_key_vault_access_policy" "app_service_access_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenet_id
  object_id    = azurerm_app_service.new_app_service.identity[0].principal_id
  
  secret_permissions = [
    "get",
    "list"
  ]
}