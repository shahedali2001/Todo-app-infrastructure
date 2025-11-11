data "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_secret.key_vault_name
  resource_group_name = var.key_vault_secret.resource_group_name
}

