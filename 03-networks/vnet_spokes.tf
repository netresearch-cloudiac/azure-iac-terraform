# Spoke networks created

locals {
  netsuffixset = toset(["1", "2", "3"])
}

resource "azurerm_resource_group" "spoke" {
  for_each = local.netsuffixset
  name     = "${var.rg_name}${each.key}"
  location = var.pry_location
}

resource "azurerm_network_security_group" "spoke" {
  for_each            = local.netsuffixset
  name                = "nsg_${each.key}"
  location            = azurerm_resource_group.spoke[each.key].location
  resource_group_name = azurerm_resource_group.spoke[each.key].name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

    security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

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

resource "azurerm_virtual_network" "spoke" {
  for_each            = local.netsuffixset
  name                = "${var.prefix}_vnet${each.key}"
  location            = azurerm_resource_group.spoke[each.key].location
  resource_group_name = azurerm_resource_group.spoke[each.key].name
  address_space       = ["10.${each.key}.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "appsub${each.key}"
    address_prefix = "10.${each.key}.1.0/24"
    security_group = azurerm_network_security_group.spoke[each.key].id
  }

  subnet {
    name           = "dmzsub${each.key}"
    address_prefix = "10.${each.key}.2.0/24"
  }

  subnet {
    name           = "mgtsub${each.key}"
    address_prefix = "10.${each.key}.3.0/24"
  }

  tags = var.tags
}

resource "azurerm_virtual_network_peering" "spoke" {
  name                      = "spokevnet1tohub"
  resource_group_name       = azurerm_resource_group.spoke["1"].name
  virtual_network_name      = azurerm_virtual_network.spoke["1"].name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
  use_remote_gateways = true
}