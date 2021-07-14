# azure region
variable location {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "North Europe"
}

# azure region shortname
variable region {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "ne"
}

# company name 
variable company {
  type        = string
  description = "This variable defines thecompany name used to build resources"
  default     = "sd"
}

# project name 
variable project {
  type        = string
  description = "This variable defines the application name used to build resources"
  default     = "burst"
}

# environment
variable environment {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "poc"
}

# owner
variable "owner" {
  type        = string
  description = "Specify the owner of the resource"
  default     = "BJSS Cloud Burst" 
}

# description
variable "description" {
  type        = string
  description = "Provide a description of the resource"
  default     = "Azure AKS poc" 
}

variable "client_id" {
   default = "48b8750e-4a96-445c-98dc-7687148e89c2"
}

variable "client_secret" {
   default = "c.pQaY.zohpBxH5-B~OFJ7z~cC6EW1_21F"
}

variable "node_count" {
  description = "number of nodes to deploy"
  default     = 2
}

variable "dns_prefix" {
  description = "DNS Suffix"
  default     = "burst-aks-poc"
}

variable cluster_name {
  description = "AKS cluster name"
  default     = "sd-ne-aks-dev-aks01"
}

variable resource_group_name {
  description = "name of the resource group to deploy AKS cluster in"
  default     = "sd-ne-aks-dev-rgall"
}

variable log_analytics_workspace_name {
  default = "sd-ne-aks-dev-ws01"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
  default = "North Europe"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}

variable vnet_name {
  description = "vnet id where the nodes will be deployed"
  default     = "sd-ne-aks-dev-vnet01"
}

variable "address_space" {
  description = "The address space that is used the virtual network"
  default     = "10.2.0.0/16"
}

variable subnet_name {
  description = "subnet id where the nodes will be deployed"
  default     = "sd-ne-aks-dev-vn01-sn01"
}

variable subnet_cidr {
  description = "the subnet cidr range"
  default     = "10.2.32.0/21"
}

variable kubernetes_version {
  description = "version of the kubernetes cluster"
  default     = "1.18.14"
}

variable "vm_size" {
  description = "size/type of VM to use for nodes"
  default     = "Standard_D2_v2"
}

variable "os_disk_size_gb" {
  description = "size of the OS disk to attach to the nodes"
  default     = 512
}

variable "max_pods" {
  description = "maximum number of pods that can run on a single node"
  default     = "50"
}

variable "min_count" {
  default     = 1
  description = "Minimum Node Count"
}
variable "max_count" {
  default     = 3
  description = "Maximum Node Count"
}













