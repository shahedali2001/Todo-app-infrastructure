output "nsg_ids" {
  value = { for k, v in azurerm_network_security_group.nsg_block : k => v.id }
}
