variable "project" {
  description = "Project name (e.g., test)"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "region" {
  description = "Azure Region"
  type        = string
}

# VM Variables
variable "vm_size" {
  description = "Size of the VM"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

# # AKS Variables
# variable "aks_node_count" {
#   description = "Number of AKS worker nodes"
#   type        = number
# }

# variable "aks_vm_size" {
#   description = "Size of the AKS worker nodes"
#   type        = string
# }