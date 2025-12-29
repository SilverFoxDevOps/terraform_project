output "key_vault_name" {
  value = local.kv_name
}

output "vm_private_ip" {
  value = module.linux_vm.private_ip
}

# Optional: Uncomment if you want to see the password in the CLI
# output "admin_password" {
#   value     = random_password.vm_admin.result
#   sensitive = true
# }