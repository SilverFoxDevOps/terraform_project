# ---------------------------------------------------------------------------------------------------------------------
# 1. GENERATE PROVIDER
# This automatically creates a 'provider.tf' file in your cache folder so you don't have to copy-paste it.
# ---------------------------------------------------------------------------------------------------------------------
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id = "773586ad-bb38-4d45-8c50-e4a3bb2021c8"
}

provider "random" {}

# We need the client config to get the Object ID of the user running Terragrunt
# This is required to set Key Vault access policies dynamically.
data "azurerm_client_config" "current" {}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. REMOTE STATE (BACKEND)
# This automatically configures where the state file is stored in Azure.
# It uses the folder structure to name the state file (e.g., dev/terraform.tfstate).
# ---------------------------------------------------------------------------------------------------------------------
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate1876"
    container_name       = "tfstate"
    
    # Magic: automatically saves state to "dev/terraform.tfstate" or "prod/terraform.tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}