output "api_gateway_identity" {
    value = module.waapigateway.app_service_identity
}

output "identity_server_identity" {
    value = module.waidentityserver.app_service_identity
}

output "product_api_identity" {
    value = module.waproductapi.app_service_identity
}

output "menu_api_identity" {
    value = module.wamenuapi.app_service_identity
}

output "storage_account_name" {
    value = azurerm_storage_account.web-sa.name
}

output "storage_account_key" {
    value       = azurerm_storage_account.web-sa.primary_access_key
    sensitive   = true
}

output "key_vault_name" {
    value = azurerm_key_vault.key_vault.name
}