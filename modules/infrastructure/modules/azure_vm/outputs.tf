output "vm_id" {
  value = try(azurerm_linux_virtual_machine.vm_linux[0].id, null)
}

output "private_ip" {
  value = try(azurerm_network_interface.nic[0].private_ip_address, null)
}