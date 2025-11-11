# ------------------------------
# Recovery Services Vaults + VMs to Backup
# ------------------------------
# variable "recovery_services_vaults" {
#   description = "Map of Recovery Services Vaults and the VMs to protect"
#   type = map(object({
#     location            = string          # Azure region
#     sku                 = string          # Vault SKU: Standard or Premium
#     resource_group_name = string          # Resource Group name
#     tags                = map(string)     # Vault tags
#     vms_to_backup       = list(string)    # List of full VM IDs to backup
#   }))
# }

variable "recovery_services_vaults" {
  description = "Map of Recovery Services Vaults with their properties"
  type = map(object({
    location            = string
    resource_group_name = string
    sku                 = string
    tags                = map(string)
  }))
}

variable "backup_policies" {
  description = "Map of Backup Policies to associate with vaults"
  type = map(object({
    backup_vault_name   = string       # key from recovery_services_vaults
    resource_group_name = string
    schedule_policy = object({
      schedule_run_frequency = string   # e.g., "Daily"
      schedule_run_time      = string   # e.g., "23:00"
    })
    retention_policy = object({
      daily_retention_count  = number   # number of days to retain backups daily
    })
  }))
}





