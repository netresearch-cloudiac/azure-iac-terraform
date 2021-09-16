terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "onpremsim"
  subscription_id = "6cf6df30-ea4d-4e5a-9271-f8514eafe15f"
}

# resource "azurerm_resource_group" "vdinetwork" {
#   count = 3
#   name     = "${var.rg_name}0${count.index}"
#   location = var.pry_location
#   tags     = var.tags
# }
