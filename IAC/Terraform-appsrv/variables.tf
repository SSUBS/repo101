# azure region
variable location {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "North Europe"
}

# company name 
variable company {
  type        = string
  description = "This variable defines thecompany name used to build resources"
  default     = "sd"
}

# azure region shortname
variable region {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "ne"
}

# application name 
variable project {
  type        = string
  description = "This variable defines the application name used to build resources"
  default     = "burst"
}

# environment
variable environment {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "test"
}

variable docker_registry_server_url {
  type        = string
  default     = "sdneburstdevcr01.azurecr.io"
  description = "Docker registry URL (without http prefix)"
}

variable docker_registry_server_username {
  type        = string
  default     = "sdneburstdevcr01"
  description = "Docker registry user name"
}

variable DOCKER_REGISTRY_SERVER_PASSWORD {
  default     = "RjMAVmbs2bCE2Q4VS5/TvkSjExocf9=7"
}