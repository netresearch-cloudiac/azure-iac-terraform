# Hub networks created

resource "azurerm_resource_group" "hub" {
  #for_each = local.netsuffixset
  name     = "${var.rg_name}-hub"
  location = var.pry_location
  tags = var.tags
}

resource "azurerm_network_security_group" "hubdmz" {
  # for_each = local.netsuffixset
  name                = "nsg_hubdmz"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = var.tags
}


resource "azurerm_virtual_network" "hub" {
  # for_each = local.netsuffixset
  name                = "${var.prefix}_vnet-hub"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["172.16.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "172.16.0.0/24"
  }

  subnet {
    name           = "commonsub"
    address_prefix = "172.16.1.0/24"
  }

  subnet {
    name           = "dmzsub"
    address_prefix = "172.16.2.0/24"
    security_group = azurerm_network_security_group.hubdmz.id
  }

  subnet {
    name           = "mgtsub"
    address_prefix = "172.16.3.0/24"
  }

  tags = var.tags
}

resource "azurerm_virtual_network_peering" "hub" {
  name                      = "hubtospokevnet1"
  resource_group_name       = azurerm_resource_group.hub.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = azurerm_virtual_network.spoke["1"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = true
  use_remote_gateways = false
}
