# # main.tf in the child module
# locals {
#   vault_names = { for k, v in var.recovery_services_vaults : k => replace(k, "_", "-") }
# }

# resource "azurerm_recovery_services_vault" "vault" {
#   for_each = var.recovery_services_vaults

#   name                = replace(each.key, "_", "-")   # replace underscores with hyphens
#   location            = each.value.location
#   resource_group_name = each.value.resource_group_name
#   sku                 = each.value.sku
#   tags                = each.value.tags
# }

# Locals to normalize vault names
locals {
  vault_names = { for k, v in var.recovery_services_vaults : k => replace(k, "_", "-") }
}

resource "azurerm_recovery_services_vault" "vault" {
  for_each = var.recovery_services_vaults

  name                = local.vault_names[each.key]
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  tags                = each.value.tags
}

resource "azurerm_backup_policy_vm" "backup_policy" {
  for_each = var.backup_policies

  name                = each.key
  resource_group_name = each.value.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault[each.value.backup_vault_name].name

  backup {
    time                = each.value.schedule_policy.schedule_run_time
    frequency           = each.value.schedule_policy.schedule_run_frequency
  }
  retention_daily {
    count = each.value.retention_policy.daily_retention_count
  }
}
  


