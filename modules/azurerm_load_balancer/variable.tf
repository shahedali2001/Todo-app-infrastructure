variable "shahed_lb" {
  description = "Map of load balancers and their configuration"
  type = map(object({
    name                      = string
    resource_group_name       = string
    location                  = string
    frontend_ipconfig_name    = string
    backend_address_pool_name = string
    lb_probe_name             = string
    protocol                  = string
    port                      = number
    interval_in_seconds       = number
    lb_rule_name              = string
    frontend_port             = number
    backend_port              = number
    idle_timeout_in_minutes   = number
  }))
}
variable "shahed_lb_nic" {
  description = "Map of NICs to associate with backend pools"
  type = map(object({
    nic_name              = string
    resource_group_name   = string
    ip_configuration_name = string
    backend_pool_key      = string
  }))
}
variable "nic_ids" {
  type = map(string)
  description = "Map of NIC IDs to associate with the backend pool"
}