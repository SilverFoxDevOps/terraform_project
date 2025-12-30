# ---------------------------------------------------------
# 1. Local Variables & Dependencies
# ---------------------------------------------------------
locals {
  # Naming Conventions
  resource_group_name = "rg-${var.project}-${var.environment}"
  vnet_name           = "vnet-${var.project}-${var.environment}"
  # KeyVault names must be globally unique, so we add a random suffix
  kv_name             = "kv-${var.project}-${var.environment}-${random_string.suffix.result}"
  aks_name            = "aks-${var.project}-${var.environment}"
  
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terragrunt"
  }
}

# Used for Unique KV Name
resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Used for Key Vault Permissions
# data "azurerm_client_config" "current" {}

# Used for Secure Password Generation
resource "random_password" "vm_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
}

# ---------------------------------------------------------
# 2. Base Network & Resource Group
# ---------------------------------------------------------
resource "azurerm_resource_group" "primary" {
  name     = local.resource_group_name
  location = var.region
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
}

resource "azurerm_subnet" "snet_compute" {
  name                 = "snet-compute-01"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet_aks" {
  name                 = "snet-aks-01"
  resource_group_name  = azurerm_resource_group.primary.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# ---------------------------------------------------------
# 3. Key Vault Module
# ---------------------------------------------------------
module "keyvault" {
  source = "./modules/azure_kv"

  name                   = local.kv_name
  location               = azurerm_resource_group.primary.location
  resource_group_name    = azurerm_resource_group.primary.name
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  
  secret_name            = "vm-admin-password"
  secret_value           = random_password.vm_admin.result
}

# ---------------------------------------------------------
# 4. VM Module
# ---------------------------------------------------------
module "linux_vm" {
  source = "./modules/azure_vm"

  is_linux            = true
  name                = "vm-${var.project}-web"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name
  size                = var.vm_size
  subnet_id           = azurerm_subnet.snet_compute.id
  
  admin_username      = var.admin_username
  admin_password      = random_password.vm_admin.result

  os_disk = {
    name                 = "osdisk-${var.environment}-01"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  tags       = local.common_tags
  depends_on = [module.keyvault]
}

# ---------------------------------------------------------
# 5. AKS Module
# ---------------------------------------------------------
# module "aks_cluster" {
#   source = "./modules/aks"


#   cluster_name        = local.aks_name
#   location            = azurerm_resource_group.primary.location
#   resource_group_name = azurerm_resource_group.primary.name
#   vnet_subnet_id      = azurerm_subnet.snet_aks.id
  
#   node_count          = var.aks_node_count
#   vm_size             = var.aks_vm_size
  
#   tags                = local.common_tags
#   depends_on          = [azurerm_virtual_network.vnet]
# }