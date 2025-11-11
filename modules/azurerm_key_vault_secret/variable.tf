variable "key_vault_secret" {
  description = "Secrets for Key Vault"
  type = object({
    key_vault_name      = string
    resource_group_name = string
    secrets             = map(string)  # secret_name => secret_value
  })
}
