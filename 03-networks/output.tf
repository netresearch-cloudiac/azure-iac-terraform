output "resrouce_group_name" {
  value = azurerm_resource_group.hub.name
}

output "vnet_address" {
  value = azurerm_virtual_network.hub.address_space
}

output "subnet_address" {
  value = azurerm_virtual_network.hub.subnet.*.id
}


output "vm_names" {
  value = azurerm_virtual_machine.hub.*.name

}
output "network_interface_private_ip_hub" {
  description = "private ip addresses of the vm nics"
  value       = azurerm_network_interface.hub.*.private_ip_address
}

# # output "public_ip_id" {
# #   description = "id of the public ip address provisoned."
# #   value       = azurerm_public_ip.slb2srv.*.id
# # }

output "public_ip_address_vmhub" {
  description = "The actual ip address allocated for Hub VM."
  value       = azurerm_public_ip.hub.*.ip_address
}

output "public_ip_address_vmspoke" {
  description = "The actual ip address allocated for Spoke VM."
  value       = azurerm_public_ip.spoke.*.ip_address
}

output "public_ip_address_ciscocsr" {
  # provider    = azurerm.onpremsim
  description = "The actual ip address allocated for onprem Cisco CSR"
  value       = azurerm_public_ip.cisco.*.ip_address
}

# output "public_ip_fqdns" {
#   description = "The actual dns names allocated for the resource."
#   value       = azurerm_public_ip.slb2srv.*.fqdn
# }


# output "public_ip_address_lb" {
#   description = "The actual ip address allocated for the resource."
#   value       = azurerm_public_ip.slbpubip.ip_address
# }

# # output "load_balancer_rules" {
# #   description = "load balancer rules"
# #   value = azurerm_lb.slb2srv.load_balancer_rules
# # }
