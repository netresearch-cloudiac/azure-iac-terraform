# Virtual Machine definition
resource "azurerm_public_ip" "slb2srv" {
  count               = var.vm_count
  name                = "${var.prefix}-pubip${count.index}"
  resource_group_name = azurerm_resource_group.slb2srv.name
  location            = azurerm_resource_group.slb2srv.location
  allocation_method   = "Static"
  domain_name_label   = "${var.prefix}-vm${count.index}"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "slb2srv" {
  count               = var.vm_count
  name                = "${var.prefix}-nic${count.index}-in"
  location            = azurerm_resource_group.slb2srv.location
  resource_group_name = azurerm_resource_group.slb2srv.name

  ip_configuration {
    name = "pvtip${count.index}"
    //subnet_id                     = azurerm_virtual_network.slb2srv.subnet.id //azurerm_subnet.internal.id
    subnet_id                     = azurerm_virtual_network.slb2srv.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.slb2srv.*.id, count.index)
  }
}

resource "azurerm_virtual_machine" "slb2srv" {
  count                 = var.vm_count
  name                  = "${var.prefix}-vm${count.index}"
  location              = azurerm_resource_group.slb2srv.location
  resource_group_name   = azurerm_resource_group.slb2srv.name
  network_interface_ids = [element(azurerm_network_interface.slb2srv.*.id, count.index)] # [azurerm_network_interface.slb2srv.id]
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
    name              = "${var.prefix}-myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.prefix}-vm"
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

resource "azurerm_virtual_machine_extension" "slb2srv" {
  count                = var.vm_count
  name                 = "iis-extension"
  virtual_machine_id   = azurerm_virtual_machine.slb2srv[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  settings             = <<SETTINGS
    {
        "commandToExecute": "powershell Install-WindowsFeature -name Web-Server -IncludeManagementTools;"
    }
SETTINGS
}
