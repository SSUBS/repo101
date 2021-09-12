# Create Azure Cognitive Service - Text Analytics

resource "azurerm_cognitive_account" "text_analytics" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.text_analytics_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "TextAnalytics"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}