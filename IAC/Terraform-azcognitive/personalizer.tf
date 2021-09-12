# Create Azure Cognitive Service - Personalizer 

resource "azurerm_cognitive_account" "personalizer" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.personalizer_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "Personalizer"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}