# Create Azure Cognitive Service - Language Understanding (LUIS)

resource "azurerm_cognitive_account" "language_understanding" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.language_understanding_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "LUIS"
  sku_name            = "F0"
  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}