output "app_service_identity" {
    value = azurerm_app_service.new_app_service.identity[0].principal_id
}