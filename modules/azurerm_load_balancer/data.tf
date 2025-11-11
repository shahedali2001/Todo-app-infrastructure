# Data source to get existing NICs
data "azurerm_network_interface" "shahed_lb_nic_data" {
  for_each = var.shahed_lb_nic
  name                = each.value.nic_name           # <-- FIXED
  resource_group_name = each.value.resource_group_name
}
