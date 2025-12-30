resource "azurerm_network_interface" "nic" {
  count               = var.is_linux ? 1 : 0
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_linux" {
  count = var.is_linux ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  
  # FIX: Referenced as a list element [0] because 'nic' now uses count
  network_interface_ids = [azurerm_network_interface.nic[0].id]

  disable_password_authentication = false

  os_disk {
    name                 = var.os_disk.name
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = var.tags
}