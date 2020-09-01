resource "azurerm_linux_virtual_machine" "docker_vm" {
  name                            = var.docker_vm_name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  computer_name                   = "docker"
  admin_username                  = "ppuczka"
  disable_password_authentication = true
  #   custom_data                     = base64encode(data.template_file.docker.rendered)
  network_interface_ids = [element(azurerm_network_interface.terranic.*.id, 1)]

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
    public_key = tls_private_key.jenkins_ssh_key.public_key_openssh
  }

}
