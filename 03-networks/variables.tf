variable "rg_name" {}

variable "pry_location" {}

variable "tags" {
  type = map(any)
}

variable "vnet_name" {}
variable "vnet_address_space" {
  type = list(any)
}
variable "vnet_subnet01" {}
variable "vnet_subnet01_name" {}
variable "vnet_subnet02" {}
variable "vnet_subnet02_name" {}
variable "prefix" {
  default = "default_prefix"
}
variable "vm_username" {
  default = "dummyadmin"
}
variable "vm_password" {
  default = "Password_123456"
}
variable "vm_count" {
  default = 1
}