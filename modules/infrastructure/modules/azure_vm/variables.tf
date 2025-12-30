variable "is_linux" {
  description = "Boolean flag to enable/disable Linux VM creation."
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the virtual machine and related resources."
  type        = string
}

variable "location" {
  description = "Azure region for the deployment."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group."
  type        = string
}

variable "size" {
  description = "The SKU size of the virtual machine."
  type        = string
  default     = "Standard_B1s"
}

variable "subnet_id" {
  description = "The ID of the subnet for the NIC."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM."
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM."
  type        = string
  sensitive   = true
}

variable "os_disk" {
  description = "Configuration object for the OS disk."
  type = object({
    name                 = string
    caching              = string
    storage_account_type = string
    disk_size_gb         = optional(number)
  })
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}