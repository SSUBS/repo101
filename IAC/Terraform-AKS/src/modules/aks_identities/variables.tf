variable "cluster_name" {
  description = "cluster name"
}

variable resource_group_name {
  description = "name of the resource group to deploy AKS cluster in"
  default     = "sd-ne-aks-dev-rgall"
}