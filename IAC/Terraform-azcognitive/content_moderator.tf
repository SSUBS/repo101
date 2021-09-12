# Create Azure Cognitive Service - Content Moderator API

resource "azurerm_cognitive_account" "content_moderator" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.content_moderator_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "ContentModerator"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}