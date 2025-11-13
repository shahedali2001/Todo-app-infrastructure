terraform {
  backend "azurerm" {
    resource_group_name   = "shahed-dev-01"
    storage_account_name  = "shahed490"
    container_name        = "shahed"
    key                   = "dev.terraform.tfstate"
    use_azuread_auth      = true
    subscription_id       = "2c6da294-c904-4801-bffd-cd7f0b236e3d"
  }
}
