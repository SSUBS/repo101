# Create Azure Cognitive Service - QnA Maker 

resource "azurerm_cognitive_account" "qnamaker" {
  depends_on           = [azurerm_resource_group.example]
  name                 = "${var.qnamaker_instance_name}"
  qna_runtime_endpoint = "${var.qnamaker_endpoint_instance_name}"
  resource_group_name  = azurerm_resource_group.example.name
  location             = azurerm_resource_group.example.location
  kind                 = "QnAMaker"
  sku_name             = "S0"

  tags = {
    "Environment" = "Dev"
    "CostCenter"  = "ML/AI"
  }

}