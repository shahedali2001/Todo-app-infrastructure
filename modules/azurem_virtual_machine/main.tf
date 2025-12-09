resource "azurerm_network_interface" "nic" {
    for_each = var.vms
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }
}
# Attach NSG to NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each = var.vms
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = var.nsg_ids[each.value.nsg_key]
}

resource "azurerm_linux_virtual_machine" "vm" {
    for_each = var.vms
  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  disable_password_authentication = false
  admin_password     = each.value.admin_password
  
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }
  #  Custom Data Block (for_each + filebase64)
  #custom_data = filebase64(each.value.custom_data_file)
}
