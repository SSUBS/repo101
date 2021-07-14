variable storage_account_name {
  type        = string
  description = "The name of the storage account to mount"
}

variable storage_account_container_name {
  type        = string
  description = "The name of the container tro share in storage account"
}

variable storage_account_access_key {
  type        = string
  description = "The access key for the storage account"
}

variable docker_registry_server_password {
  type        = string
  description = "Docker registry password"
}

variable docker_image_name {
  type        = string
  description = "Docker image name and tag"
}

variable docker_registry_server_url {
  type        = string
  description = "Docker registry url"
}

variable docker_registry_server_username {
  type        = string
  description = "Docker registry username"
}

variable name {
  type        = string
  description = "Name of the app service"
}

variable location {
  type        = string
  description = "Resource location"
}

variable resource_group {
  type        = string
  description = "Resource group"
}

variable app_service_plan_id {
  type        = string
  description = "App service plan ID"
}

variable subnet_id {
  type        = string
  description = "ID of subnet to integrate with app service"
}

variable key_vault_id {
  type        = string
  description = "ID of keyvault to grant get list permissions to"
}

variable tenet_id {
  type        = string
  description = "Tenet ID"
}

variable aspnetcore_environment {
  type        = string
  default     = "Production"
  description = "ASP.Net Core environment environment variable"
}
