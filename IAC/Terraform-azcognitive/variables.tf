variable "subscription_id" {
  type        = string
  description = "The Subscription Id for Azure account"
}

variable "client_id" {
  type        = string
  description = "The Client Id of the service principal"
}

variable "client_secret" {
  type        = string
  description = "The client secret of the service pricipal"
}

variable "tenant_id" {
  type        = string
  description = "the tenant Id of the directory"
}

variable "azure_resource_group_name" {
  type        = string
  description = "The resource group of Azure Firewall resource"
}

variable "azure_resource_group_location" {
  type        = string
  description = "The location of the resource group"
}

variable "anamoly_detector_instance_name" {
  type        = string
  description = "The Anamoly Detection API name"

}

variable "computer_vision_instance_name" {
  type        = string
  description = "The Computer Vision API name"
}

variable "content_moderator_instance_name" {
  type        = string
  description = "The Content moderator API name"
}

variable "custom_vision_instance_name" {
  type        = string
  description = "The Custom Vision API name"
}

variable "face_api_instance_name" {
  type        = string
  description = "The Face API name"
}

variable "form_recognizer_instance_name" {
  type        = string
  description = "The Form Recognizer API name"
}

variable "language_understanding_instance_name" {
  type        = string
  description = "The LUIS API name"
}

variable "personalizer_instance_name" {
  type        = string
  description = "The Personalizer API name"
}

variable "qnamaker_instance_name" {
  type        = string
  description = "The QnAMaker API name"
}

variable "qnamaker_endpoint_instance_name" {
  type        = string
  description = "The QnA maker endpoint name"
}

variable "speech_instance_name" {
  type        = string
  description = "The Speech API name"
}

variable "text_analytics_instance_name" {
  type        = string
  description = "The Text Analytics API name"
}

variable "text_translation_instance_name" {
  type        = string
  description = "The Text Translation API name"
}

variable "immersive_reader_instance_name" {
  type        = string
  description = "The Immersive Reader instance name"

}
