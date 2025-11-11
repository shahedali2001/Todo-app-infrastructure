variable "rgs" {
  description = "Resource groups to create"
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = map(string)

  }))
}



