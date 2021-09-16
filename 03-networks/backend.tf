#  authenticating using the Azure CLI or a Service Principal (either with a Client Certificate or a Client Secret):

terraform {
  backend "azurerm" {
    resource_group_name  = "RG-common-base"
    storage_account_name = "tfcmmgtstatestore"
    container_name       = "tfstatecontainer"
    key                  = "backendsetup.terraform.tfstate"
  }
}