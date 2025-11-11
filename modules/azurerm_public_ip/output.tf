output "public_ip_ids" {
  description = "Map of Public IP IDs created"
  value       = { for k, pip in azurerm_public_ip.publicip : k => pip.id }
}
