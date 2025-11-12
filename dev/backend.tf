terraform {
  backend "azurerm" {
    resource_group_name  = "shahed-dev-01"
    storage_account_name = "shahed490"
    container_name       = "shahed"
    key                  = "dev.terraform.tfstate"
  }
}
