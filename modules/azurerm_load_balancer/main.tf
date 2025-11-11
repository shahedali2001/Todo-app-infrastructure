# Create Public IPs for each Load Balancer
resource "azurerm_public_ip" "shahed_lb_public_ip" {
  for_each            = var.shahed_lb
  name                = "${each.key}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Load Balancer
resource "azurerm_lb" "shahed_lb" {
  for_each            = var.shahed_lb
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = each.value.frontend_ipconfig_name
    public_ip_address_id = azurerm_public_ip.shahed_lb_public_ip[each.key].id
  }
}

# Backend Pool
resource "azurerm_lb_backend_address_pool" "shahed_lb_backend_address_pool" {
  for_each        = var.shahed_lb
  name            = each.value.backend_address_pool_name
  loadbalancer_id = azurerm_lb.shahed_lb[each.key].id
}

# Associate NICs with Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "shahed_lb_backend_address_pool_address" {
  for_each = var.shahed_lb_nic

  network_interface_id    = data.azurerm_network_interface.shahed_lb_nic_data[each.key].id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.shahed_lb_backend_address_pool[each.value.backend_pool_key].id
}


# Health Probe
resource "azurerm_lb_probe" "shahed_lb_probe" {
  for_each            = var.shahed_lb
  name                = each.value.lb_probe_name
  loadbalancer_id     = azurerm_lb.shahed_lb[each.key].id
  protocol            = each.value.protocol
  port                = each.value.port
  interval_in_seconds = each.value.interval_in_seconds
}

# Load Balancer Rule
resource "azurerm_lb_rule" "shahed_lb_rule" {
  for_each     = var.shahed_lb
  name                           = each.value.lb_rule_name
  loadbalancer_id                = azurerm_lb.shahed_lb[each.key].id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = each.value.frontend_ipconfig_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.shahed_lb_backend_address_pool[each.key].id]
  probe_id                       = azurerm_lb_probe.shahed_lb_probe[each.key].id
  idle_timeout_in_minutes        = each.value.idle_timeout_in_minutes
}
