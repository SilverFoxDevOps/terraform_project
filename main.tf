# ---------------------------------------------------------
# 1. Base Infrastructure (RG, VNet, Subnet)
# -------------------------------------------- -------------
resource "azurerm_resource_group" "primary" {
  name     = local.resource_group_name
  location = local.region
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
}

resource "azurerm_subnet" "snet" {
  name                 = "snet-compute-01"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ---------------------------------------------------------
# 2. Security (Password Generation & Key Vault)
# ---------------------------------------------------------
resource "random_password" "vm_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}

module "keyvault" {
  source = "./modules/azure_kv"

  name                = local.kv_name
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  
  # Permission details
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id

  # Secret details
  secret_name  = "vm-admin-password"
  secret_value = random_password.vm_admin.result
}

# ---------------------------------------------------------
# 3. Compute (VM Module)
# ---------------------------------------------------------
module "linux_vm" {
  source = "./modules/azure_vm"

  is_linux            = true
  name                = "vm-${local.project}-web"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  size                = "Standard_B2ats_v2"
  subnet_id           = azurerm_subnet.snet.id
  
  admin_username      = "azureadmin"
  
  # Inject the generated password
  admin_password      = random_password.vm_admin.result

  os_disk = {
    name                 = "osdisk-web-01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  tags = local.common_tags

  # Ensure the Key Vault secret is stored before we try to create the VM
  depends_on = [module.keyvault]
}
