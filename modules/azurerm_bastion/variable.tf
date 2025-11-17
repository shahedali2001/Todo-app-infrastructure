variable "bastion_hosts" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
   

# Required block
ip_configuration = object({
  name                 = string
  subnet_id            = string
  
})
  # public_ip_ids = optional(map(string), {})
# Optional Arguments
    copy_paste_enabled        = optional(bool)
    file_copy_enabled         = optional(bool)
    sku                       = optional(string)
    ip_connect_enabled        = optional(bool)
    kerberos_enabled          = optional(bool)
    scale_units               = optional(number)
    shareable_link_enabled    = optional(bool)
    tunneling_enabled         = optional(bool)
    session_recording_enabled = optional(bool)
    virtual_network_id        = optional(string)
    tags                      = optional(map(string))
    zones                     = optional(list(string))
  }))
}
 variable "public_ip_ids" {
  type = map(string)
   
 }