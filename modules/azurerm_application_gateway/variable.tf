# modules/azurerm_application_gateway/variables.tf

# Application Gateway ka high-level config
variable "application_gateways" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    location             = string
    virtual_network_name = string

    # <- yahi nested object hai jise tum main.tf me each.value.sku.* use kar rahe ho
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })

    gateway_ip_configuration = object({
      name        = string
      subnet_name = string
    })

    frontend_ports = list(object({
      name = string
      port = number
    }))

    frontend_ip_configurations = list(object({
      name          = string
      public_ip_key = string   # is key se hum var.public_ip_ids map se id nikalenge
    }))

    backend_address_pools = list(object({
      name = string
    }))

    backend_http_settings = list(object({
      name                  = string
      cookie_based_affinity = string
      path                  = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))

    http_listeners = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
    }))

    request_routing_rules = list(object({
      name                       = string
      priority                   = number
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))

    tags = map(string)
  }))
}

# Public IP IDs ka map: key = tumhara public_ip_key, value = resource ID
variable "public_ip_ids" {
  type = map(string)
}
