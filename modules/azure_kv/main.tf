resource "azurerm_key_vault" "kv" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  # Access policy for the user/SP running Terraform
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.current_user_object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }
}

resource "azurerm_key_vault_secret" "vm_pass" {
  name         = var.secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault.kv]
}