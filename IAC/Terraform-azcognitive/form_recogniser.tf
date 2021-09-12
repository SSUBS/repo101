# Create Azure Cognitive Service - Form Recognizer API

resource "azurerm_cognitive_account" "form_recognizer" {
  depends_on          = [azurerm_resource_group.example]
  name                = "${var.form_recognizer_instance_name}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kind                = "FormRecognizer"
  sku_name            = "F0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}