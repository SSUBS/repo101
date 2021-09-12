# Deploy ARO using ARM template

resource "azurerm_template_deployment" "aro-cluster" {
  name                          = "sd-ne-aro-dev-aro01"
  resource_group_name           = azurerm_resource_group.aro-poc-rg.name

  template_body = file("./ARM-openShiftClusters.json")

  parameters = {
    "clientId"                 = var.clientId
    "clientSecret"             = var.clientSecret
    "clusterName"              = "sd-ne-aro-dev-aro01"
    "clusterResourceGroupName" = azurerm_resource_group.aro-poc-rg.name
    "domain"                   = azurerm_private_dns_zone.private-dns-zone.name
    "location"                 = var.location
    "masterSubnetId"           = azurerm_subnet.master-subnet.id
    "workerSubnetId"           = azurerm_subnet.worker-subnet.id
    "pullSecret"               = file("./pull-secret.txt")
    "tags"                     = jsonencode(local.common_tags)
  }

  deployment_mode = "Incremental"

  depends_on = [
    azurerm_subnet.master-subnet,
    azurerm_subnet.worker-subnet
  ]
}
