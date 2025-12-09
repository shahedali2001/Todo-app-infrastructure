# output "app_gateway_id" {
#   description = "Map of Application Gateway IDs"
#   value       = { for k, agw in azurerm_application_gateway.app_gateways : k => agw.id }
# }

# # output "app_gateway_frontend_ip" {
# #   value       = azurerm_application_gateway.app_gateways[*].frontend_ip_configuration[0].public_ip_address_id
# #   description = "Application Gateway frontend Public IP IDs"
# # }
