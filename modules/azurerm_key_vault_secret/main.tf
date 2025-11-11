resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.key_vault_secret.secrets

  name         = each.key
  value        = each.value
  key_vault_id = data.azurerm_key_vault.keyvault.id
}
# data "azurerm_key_vault" "keyvault" {
#   name                = var.key_vault_secret.key_vault_name
#   resource_group_name = var.key_vault_secret.resource_group_name
# }

