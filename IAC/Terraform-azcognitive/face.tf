# Create Azure Cognitive Service - Face API

resource "azurerm_cognitive_account" "face" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.face_api_instance_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "Face"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}