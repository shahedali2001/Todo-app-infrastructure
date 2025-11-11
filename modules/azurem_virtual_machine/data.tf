data "azurerm_subnet" "subnet" {
  for_each = var.vms

  name                 = each.value.subnet_name            
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

# data "azurerm_public_ip" "pip" {
#   for_each = var.vms

#   name                = each.value.pip_name               
#   resource_group_name = each.value.resource_group_name
# }

# data "azurerm_network_security_group" "nsg" {
#   for_each = var.vm_nsgs
#   name                = each.value.nsg_name
#   resource_group_name = each.value.resource_group_name
# }
output "nic_ids" {
  description = "Map of NIC IDs created for the VMs"
  value = { for k, vm in azurerm_linux_virtual_machine.vm : k => vm.network_interface_ids[0] }
}

