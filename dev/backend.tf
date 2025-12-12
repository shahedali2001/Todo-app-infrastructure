terraform {
  backend "azurerm" {
    storage_account_name = "libo4520"
    container_name       = "tfscontainer"
    key                  = "dev.terraform.tfstate"
    resource_group_name  = "libo-rg"
    subscription_id      = "711f9f70-1892-49fb-a04f-5bf2c5a89677"
    use_azuread_auth     = true
  }
}
