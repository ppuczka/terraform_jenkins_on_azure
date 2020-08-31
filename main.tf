terraform {

  backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "tfstate8080"
    container_name       = "jenkins-tfstate"
    key                  = "terraform.tfstate"

  }
}
provider "azurerm" {
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "jenkins_rg" {
  name     = var.rg_name
  location = var.location
}
