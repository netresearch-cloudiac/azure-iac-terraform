# data "azurerm_resource_group" "rg" {
#   name = "${var.rg_name}"
# }

# data "azurerm_virtual_network" "current" {
#   name                = "${var.vnet_name}"
#   resource_group_name = "${data.azurerm_resource_group.rg.name}"
# }

# data "azurerm_subnet" "public" {
#   name                 = "${data.azurerm_virtual_network.current.subnets[0]}"
#   virtual_network_name = "${data.azurerm_virtual_network.current.name}"
#   resource_group_name  = "${data.azurerm_resource_group.rg.name}"
# }


resource "azurerm_public_ip" "cisco" {
  provider                = azurerm.onpremsim
  name                    = "cisco-pubip"
  location                = azurerm_resource_group.core.location
  resource_group_name     = azurerm_resource_group.core.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label = "${var.prefix}-csr1konprem"
  tags                    = var.tags
}

# resource "azurerm_route_table" "RTPrivate" {
#     name = "cisco_vpn_route_table"
#     location = "${var.azure_region}"
#     resource_group_name = "${data.azurerm_resource_group.rg.name}"

#     route {
#         name = "CiscoRouter"
#         address_prefix = "${coalesce(var.destination_cidr, data.template_file.terraform-dcos-default-cidr.rendered)}"
#         next_hop_type = "VirtualAppliance"
#         next_hop_in_ip_address = "${azurerm_network_interface.cisco_nic.private_ip_address}"
#     }
# }

resource "azurerm_network_interface" "cisco_nic" {
  provider             = azurerm.onpremsim
  name                 = "cisco_nic"
  location             = azurerm_resource_group.core.location
  resource_group_name  = azurerm_resource_group.core.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "pvtip_cisco"
    subnet_id                     = azurerm_virtual_network.core.subnet.*.id[2]
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.cisco.id
  }
}

# data "template_file" "terraform-dcos-default-cidr" {
#   template = "$${cloud == "aws" ? "10.0.0.0/16" : cloud == "gcp" ? "10.64.0.0/16" : "undefined"}"

#   vars {
#     cloud = "${var.terraform_dcos_destination_provider}"
#   }
# }

data "azurerm_platform_image" "cisco_csr_image" {
  provider  = azurerm.onpremsim
  location  = azurerm_resource_group.core.location
  publisher = "cisco"
  offer     = "cisco-csr-1000v"
  sku       = "16_6"
}

#resource "azurerm_availability_set" "cisco_aset" {
#  TODO (mbernadin): Optional HA
#  name                = "cisco_availibility_set"
#  location            = "${data.azurerm_resource_group.rg.location}"
#  resource_group_name = "${data.azurerm_resource_group.rg.name}"
#}

resource "azurerm_virtual_machine" "cisco" {
  provider                     = azurerm.onpremsim
  name                         = "csr1000v"
  location                     = azurerm_resource_group.core.location
  resource_group_name          = azurerm_resource_group.core.name
  network_interface_ids        = [azurerm_network_interface.cisco_nic.id]
  primary_network_interface_id = azurerm_network_interface.cisco_nic.id

  plan {
    name      = "16_12-byol"
    product   = "cisco-csr-1000v"
    publisher = "cisco"
  }
  vm_size = "Standard_D2_v2"
  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "16_12-byol"
    version   = "latest"
  }

  storage_os_disk {
    name              = "cisco-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  delete_os_disk_on_termination = true
  os_profile {
    computer_name  = "csr1000v"
    admin_username = var.vm_username
    admin_password = var.vm_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags

  #  os_profile_linux_config {
  #    disable_password_authentication = true
  #    ssh_keys {
  #        path     = "/home/${var.cisco_user}/.ssh/authorized_keys"
  #        key_data = "${var.ssh_pub_key}"
  #    }
  #  }

}
