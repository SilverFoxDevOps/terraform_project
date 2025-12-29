variable "name" {
  description = "The name of the Key Vault. Must be globally unique."
  type        = string
}

variable "location" {
  description = "The Azure region where the Key Vault should be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault."
  type        = string
}

variable "current_user_object_id" {
  description = "The Object ID of the user or service principal running Terraform. Used to grant access policies."
  type        = string
}

variable "secret_name" {
  description = "The name of the secret to be created in the Key Vault."
  type        = string
}

variable "secret_value" {
  description = "The value of the secret to store in the Key Vault."
  type        = string
  sensitive   = true
}