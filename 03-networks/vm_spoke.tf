# Virtual Machine definition
resource "azurerm_public_ip" "spoke" {
  name                = "${var.prefix}-spokedmz-pubip"
  resource_group_name = azurerm_resource_group.spoke["1"].name
  location            = azurerm_resource_group.spoke["1"].location
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-vmsp1"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "spoke" {
  name                = "${var.prefix}-spokeweb-nic"
  resource_group_name = azurerm_resource_group.spoke["1"].name
  location            = azurerm_resource_group.spoke["1"].location

  ip_configuration {
    name = "pvtip-spokeweb"
    //subnet_id                     = azurerm_virtual_network.spoke.subnet.id //azurerm_subnet.internal.id
    subnet_id                     = azurerm_virtual_network.spoke["1"].subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke.id
  }
}

resource "azurerm_virtual_machine" "spoke" {
  name                  = "${var.prefix}vmsp"
  resource_group_name   = azurerm_resource_group.spoke["1"].name
  location              = azurerm_resource_group.spoke["1"].location
  network_interface_ids = [azurerm_network_interface.spoke.id] # [azurerm_network_interface.spoke.id]
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
    name              = "${var.prefix}-myosdiskvmsp1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vmsp1"
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

resource "azurerm_virtual_machine_extension" "spoke" {
  name                 = "iis-extension"
  virtual_machine_id   = azurerm_virtual_machine.spoke.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}
