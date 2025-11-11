# Fetch current client configuration (Tenant ID, Object ID, Subscription ID)
data "azurerm_client_config" "current" {}

# Optional: If you want to fetch details of existing resource groups
# This ensures Terraform validates that the given RGs exist
data "azurerm_resource_group" "rg" {
  for_each = var.key_vaults
  name     = each.value.resource_group_name
}
