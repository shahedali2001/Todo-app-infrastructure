variable "app_gateways" {
  description = "Map of Application Gateway definitions"
  type = map(object({
    name                        : string
    location                    : string
    resource_group_name         : string
    sku_name                    : string
    capacity                    : number
    frontend_ipconfig_name      : string
    backend_address_pool_name   : string
    backend_http_settings_name  : string
    backend_port                : number
    frontend_port               : number
    protocol                    : string
    http_listener_name          : string
    request_routing_rule_name   : string
    probe_name                  : string
    
  }))
}
variable "public_ip_ids" {
  description = "Map of public IP IDs to use in frontend_ip_configuration"
  type        = map(string)
}
variable "subnet_ids" {
  description = "Map of subnet IDs to use in the application gateway"
  type        = map(string)
}
