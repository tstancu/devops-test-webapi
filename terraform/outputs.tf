output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

output "public_ip_address" {
  value = azurerm_windows_virtual_machine.vmss.public_ip_address
}

output "admin_password" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.vmss.admin_password
}