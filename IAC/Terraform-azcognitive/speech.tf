# Create Azure Cognitive Service - Speech API

resource "azurerm_cognitive_account" "speech" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.speech_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "F0"
  kind                = "SpeechServices"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }


}