provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "random" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate1876"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# This data source gets the details of the user running Terraform
# We need this to give YOU permission to write to the Key Vault
data "azurerm_client_config" "current" {}