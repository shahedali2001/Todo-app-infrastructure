
resource "azurerm_log_analytics_workspace" "log_analytics" {
  for_each = var.log_analytics_workspaces

  name                = replace(each.key, "_", "-")
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days
}
