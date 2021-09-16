# Virtual Machine definition
resource "azurerm_public_ip" "hub" {
  name                = "${var.prefix}-hubdmz-pubip"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-vmdmz"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "hub" {
  name                = "${var.prefix}-hubdmz-nic"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  ip_configuration {
    name = "pvtip-hubdmz"
    //subnet_id                     = azurerm_virtual_network.hub.subnet.id //azurerm_subnet.internal.id
    subnet_id                     = azurerm_virtual_network.hub.subnet.*.id[2]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hub.id
  }
}

resource "azurerm_virtual_machine" "hub" {
  name                  = "${var.prefix}-vmdmz"
  location              = azurerm_resource_group.hub.location
  resource_group_name   = azurerm_resource_group.hub.name
  network_interface_ids = [azurerm_network_interface.hub.id] # [azurerm_network_interface.hub.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  # if Linux image
  # storage_image_reference {
  #   publisher = "Canonical"
  #   offer     = "UbuntuServer"
  #   sku       = "16.04-LTS"
  #   version   = "latest"
  # }

  # Windows image
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-myosdiskvmdmz"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vmdmz"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }
  # os_profile_linux_config {
  #   disable_password_authentication = false
  # }
  os_profile_windows_config {
    enable_automatic_upgrades = true
    provision_vm_agent        = true
  }

  tags = var.tags
}

# resource "azurerm_virtual_machine_extension" "hub" {
#   count                = var.vm_count
#   name                 = "iis-extension"
#   virtual_machine_id   = azurerm_virtual_machine.hub[count.index].id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"
#   settings             = <<SETTINGS
#     {
#         "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
#     }
# SETTINGS
# }
