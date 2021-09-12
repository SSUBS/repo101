# Create Azure Cognitive Service - Immersive Reader API

resource "azurerm_cognitive_account" "immersive_reader" {
  depends_on          = [azurerm_resource_group.example]
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "${var.immersive_reader_instance_name}"
  sku_name            = "S1"
  kind                = "ImmersiveReader"
  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}