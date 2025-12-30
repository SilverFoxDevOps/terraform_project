# ---------------------------------------------------------------------------------------------------------------------
# 1. INHERIT PARENT CONFIG
# This pulls in the provider and backend config from the root terragrunt.hcl
# ---------------------------------------------------------------------------------------------------------------------
include {
  path = find_in_parent_folders()
}

# ---------------------------------------------------------------------------------------------------------------------
# 2. SOURCE CODE
# Point to where your Terraform modules are located (2 levels up)
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  source = "../../../modules/infrastructure"
}

# ---------------------------------------------------------------------------------------------------------------------
# 3. INPUTS (VARIABLES)
# These values are passed to your variables.tf in the module
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  project     = "test"
  environment = "dev"
  region      = "South India"

  # VM Configuration
  # 'Standard_B1s' is chosen for free-tier/low-cost availability
  vm_size        = "Standard_B2ats_v2"
  admin_username = "azureadmin"

  # AKS Configuration
  # 'Standard_B2ms' (2 vCPU, 8GB RAM) is the minimum recommended for a stable test cluster
#   aks_node_count = 1
#   aks_vm_size    = "Standard_B2ms"
}