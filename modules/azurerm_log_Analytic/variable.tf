variable "log_analytics_workspaces" {
  description = "Map of Log Analytics workspaces to create"
  type = map(object({
    location           : string
    sku                : string
    retention_in_days  : number
    resource_group_name: string
  }))
}

