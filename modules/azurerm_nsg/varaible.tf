variable "nsgs" {
  description = "Map of Network Security Groups (NSGs) to create. Each key is the NSG identifier, used for referencing in VMs."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    security_rules      = list(object({
      name                                  = string
      priority                              = number
      direction                             = string
      access                                = string
      protocol                               = string
      description                            = optional(string, null)
      source_port_range                      = optional(string, null)
      source_port_ranges                     = optional(list(string), [])
      destination_port_range                 = optional(string, null)
      destination_port_ranges                = optional(list(string), [])
      source_address_prefix                  = optional(string, null)
      source_address_prefixes                = optional(list(string), [])
      source_application_security_group_ids  = optional(list(string), [])
      destination_address_prefix             = optional(string, null)
      destination_address_prefixes           = optional(list(string), [])
      destination_application_security_group_ids = optional(list(string), [])
    }))
    tags = optional(map(string), {})  # default to empty map if not provided
  }))
  default = {}  # optional: start with empty map
}
