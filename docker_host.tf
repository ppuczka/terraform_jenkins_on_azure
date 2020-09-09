resource "azurerm_linux_virtual_machine" "docker_vm" {
  name                            = var.docker_vm_name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  computer_name                   = "docker"
  admin_username                  = "ppuczka"
  disable_password_authentication = true
  #   custom_data                     = base64encode(data.template_file.docker.rendered)
  network_interface_ids           = [azurerm_network_interface.terranic-2.id]        
#   [element(azurerm_network_interface.terranic.*.id, 1)]

  os_disk {
    name                 = "docker_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "ppuczka"
    public_key = file("~/.ssh/id_rsa.pub")
  }
} 

resource "azurerm_virtual_machine_extension" "docker_vm_pe_install" {
  name ="PEAgentInstallLinux"
  virtual_machine_id = azurerm_linux_virtual_machine.docker_vm.id
  publisher ="Microsoft.Azure.Extensions"
  type ="CustomScript"
  type_handler_version ="2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "curl -k https://puppet-master.sddwbsxqlqnexjqv1uwjaleqcg.ax.internal.cloudapp.net:8140/packages/current/install.bash | sudo bash"
    }
SETTINGS

}
