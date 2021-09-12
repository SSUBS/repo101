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
  default     = "Azure RedHat OpenShift poc" 
}

#
variable "pull-secret" {
  default = {}
}

variable "client_object_id" {
  description = "The Application ID used by the Azure Red Hat OpenShift"
}

variable "clientId" {
  description = "The Application ID used by the Azure Red Hat OpenShift"
}

variable "clientSecret" {
  description = "The Application Secret used by the Azure Red Hat OpenShift"
}

# az provider show --namespace Microsoft.RedHatOpenShift --query "id"
variable "rp_object_id" {
  description = "The Resource Provider ID for Azure Red Hat OpenShift"
}

variable "roles" {
  description = "Roles to be assigned to the Principal"
  type        = list(object({ role = string }))
  default = [
    {
      role = "Contributor"
    },
    {
      role = "User Access Administrator"
    }
  ]
}
