resource "azurerm_application_gateway" "app_gateways" {
  for_each            = var.app_gateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {
    name     = each.value.sku_name
    tier     = "Standard_v2"
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.subnet_ids["agw1"]  # From tfvars
  }

 frontend_ip_configuration {
  name                 = each.value.frontend_ipconfig_name
  public_ip_address_id = var.public_ip_ids["agw_dev"]
}

  backend_address_pool {
    name = each.value.backend_address_pool_name
  }

  backend_http_settings {
    name                  = each.value.backend_http_settings_name
    port                  = each.value.backend_port
    protocol              = each.value.protocol
    cookie_based_affinity = "Disabled"
    request_timeout       = 20
  }

  frontend_port {
    name = "frontend-port"
    port = each.value.frontend_port
  }

  http_listener {
    name                           = each.value.http_listener_name
    frontend_ip_configuration_name = each.value.frontend_ipconfig_name
    frontend_port_name             = "frontend-port"
    protocol                       = each.value.protocol
  }

  request_routing_rule {
    name                       = each.value.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = each.value.http_listener_name
    backend_address_pool_name  = each.value.backend_address_pool_name
    backend_http_settings_name = each.value.backend_http_settings_name
  }

  probe {
    name                = each.value.probe_name
    protocol            = each.value.protocol
    host                = "localhost"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  tags = {
    environment = "dev"
    app         = "appgw"
  }
}

