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
  default     = "Burst SQL managed instance" 
}

# resource group
variable "resource_group_name" {
  type        = string
  description = "azure resource group"
  default     = "sd-ne-burst-test-rgdb" 
}

# Vnet for SQL MI
variable sql_vnet_name {
  description = "vnet id where the nodes will be deployed"
  default     = "sd-ne-burst-test-vnet02"
}

variable "vnet_address" {
  description = "The address space that is used the virtual network"
  default     = "172.17.232.0/23"
}

# Subnet SQL01
variable subnet_sql01 {
  description = "subnet id where the nodes will be deployed"
  default     = "sd-ne-burst-test-snsql01"
}

variable subnet_address_sql01 {
  description = "the SQL MI subnet range"
  default     = "172.17.232.0/24"
}

variable subnet_swwebdel01 {
  description = "subnet id where the nodes will be deployed"
  default     = "sd-ne-burst-test-snwebdel01"
}

variable subnet_address_swwebdel01 {
  description = "the delegate subnet range"
  default     = "172.17.233.0/25"
}

variable subnet_swwebdel02 {
  description = "subnet id where the nodes will be deployed"
  default     = "sd-ne-burst-test-snwebdel01"
}

variable subnet_address_swwebdel02 {
  description = "the subnet cidr range"
  default     = "172.17.233.128/25"
}









