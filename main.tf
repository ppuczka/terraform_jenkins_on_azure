terraform {

  backend "azurerm" {
    resource_group_name  = "terraformstate"
    storage_account_name = "tfstate8080"
    container_name       = "jenkins-tfstate"
    key                  = "terraform.tfstate"

  }
}
provider "azurerm" {
  version = "=2.26.0"
  features {
    # virtual_machine {
    #   delete_os_disk_on_deletion = false
    # }
  }
}

resource "azurerm_resource_group" "devops_rg" {
  name     = var.rg_name
  location = var.location
}
