output "resource_group_name" {
  value = azurerm_resource_group.primary.name
}

output "vm_private_ip" {
  description = "Private IP of the created VM"
  value       = module.linux_vm.private_ip
}

# output "aks_cluster_name" {
#   description = "Name of the created AKS cluster"
#   value       = module.aks_cluster.aks_name
# }

output "key_vault_name" {
  description = "Name of the Key Vault where secrets are stored"
  value       = local.kv_name
}