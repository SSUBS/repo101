# Create Azure Cognitive Service - Text Translation 

resource "azurerm_cognitive_account" "text_translation" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.text_translation_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "TextTranslation"
  sku_name            = "S0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}