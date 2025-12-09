module "azurerm_resource_group" {
    source = "../modules/azurerm_resource_group"
    rgs = var.rgs
  
}
module "azurerm_storage_account" {
    source = "../modules/azurerm_storage_account"
    storages = var.storages
    depends_on = [ module.azurerm_resource_group ]
  
}
module "azurerm_virtual_network" {
    source = "../modules/azurerm_virtual_network"
    vnets = var.vnets
    depends_on = [ module.azurerm_resource_group ]
  
}
module "azurerm_public_ip" {
    source = "../modules/azurerm_public_ip"
    pips = var.pips
   depends_on = [ module.azurerm_resource_group ]
}
module "azurerm_network_security_group" {
  
  source = "../modules/azurerm_nsg"
  nsgs = var.nsgs
  depends_on = [ module.azurerm_virtual_network ]
}
module "azurerm_linux_virtual_machine" {
    source = "../modules/azurem_virtual_machine"
    vms = var.vms
    nsg_ids = module.azurerm_network_security_group.nsg_ids
    depends_on = [ module.azurerm_resource_group,module.azurerm_virtual_network,module.azurerm_public_ip ]
  
}
module "azurerm_key_vault" {
    source = "../modules/azurerm_key_vault"
    key_vaults = var.key_vaults
    depends_on = [ module.azurerm_resource_group ]
  
}
# module "azurerm_key_vault_secret" {
#     source = "../modules/azurerm_key_vault_secret"
#     key_vault_secret = var.key_vault_secret
#     depends_on = [ module.azurerm_resource_group,module.azurerm_key_vault ]
  
# }
module "azurerm_mssql_server_database" {
    source = "../modules/azurerm_mssqlserver+database"
    mssql_servers = var.mssql_servers
    mssql_databases = var.mssql_databases
    depends_on = [ module.azurerm_resource_group ]
  
}
module "azurerm_log_analytics_workspace" {
    source = "../modules/azurerm_log_Analytic"
    log_analytics_workspaces = var.log_analytics_workspaces
    depends_on = [ module.azurerm_resource_group ]
  
}
module "azurerm_recovery_services_vault" {
    source = "../modules/azurerm_recovery_vault"
    recovery_services_vaults = var.recovery_services_vaults
    backup_policies = var.backup_policies
    depends_on = [ module.azurerm_resource_group,module.azurerm_key_vault]
  
}
# module "azurerm_load_balancer" {
#   source = "../modules/azurerm_load_balancer"
#   shahed_lb = var.shahed_lb
#   shahed_lb_nic = var.shahed_lb_nics
#   nic_ids = module.azurerm_linux_virtual_machine.nic_ids
#   depends_on = [ module.azurerm_linux_virtual_machine ]
# }

module "azurerm_bastion" {
    source = "../modules/azurerm_bastion"
    bastion_hosts = var.bastion_hosts
    public_ip_ids  = module.azurerm_public_ip.public_ip_ids
    depends_on = [ module.azurerm_resource_group,module.azurerm_linux_virtual_machine ]
  
}
module "application_gateway" {
  source = "../modules/azurerm_application_gateway"

  # Root var ko child module ke var se map kar rahe hain
  application_gateways = var.application_gateways

  # Public IP IDs map – keys must match frontend_ip_configurations.public_ip_key
  public_ip_ids        = module.azurerm_public_ip.public_ip_ids

  depends_on = [module.azurerm_virtual_network]
}