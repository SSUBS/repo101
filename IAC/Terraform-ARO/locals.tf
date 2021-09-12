# Local values are like a function's temporary local variables

locals {
  common_tags = {
    owner        = var.owner  
    project      = var.project
    description  = var.description
  }
}

locals {
  domain_name = "sd-aro-poc.com"
}
