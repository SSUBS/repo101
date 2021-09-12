# Create Azure Cognitive Service - Computer Vision

resource "azurerm_cognitive_account" "computer_vision" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.computer_vision_instance_name}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "ComputerVision"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}