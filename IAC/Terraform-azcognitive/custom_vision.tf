# Create Azure Cognitive Service - Custom Vision

resource "azurerm_cognitive_account" "custom_vision" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.custom_vision_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "CustomVision.Prediction"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}