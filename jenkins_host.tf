resource "azurerm_linux_virtual_machine" "jenkins_vm" {
  name                            = var.jenkins_vm_name
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  computer_name                   = "jenkins"
  admin_username                  = "ppuczka"
  disable_password_authentication = true
  #   custom_data                     = base64encode(data.template_file.docker.rendered)
  network_interface_ids = [azurerm_network_interface.terranic-1.id]

  os_disk {
    name                 = "jenkins_os_disk"
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

  provisioner "puppet" {
    server              = "pp-puppetmaster.westeurope.cloudapp.azure.com"
    server_user         = "root"
    autosign            = false
    open_source         = false
    extension_requests  = {
      pp_role = "agent"
    }
      connection {
        type        = "ssh"
        user        = "ppuczka"
        host        = azurerm_public_ip.ip-1.ip_address
        private_key = tls_private_key.jenkins_ssh_key.private_key_pem
      }
  }
}
