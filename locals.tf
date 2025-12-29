locals {
  project      = "test"
  environment  = "poc"
  region       = "eastus"

  # Naming Conventions
  resource_group_name = "rg-${local.project}-${local.environment}"
  vnet_name           = "vnet-${local.project}-${local.environment}"
  kv_name             = "kv-${local.project}-${local.environment}-01" # Must be globally unique
  
  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}