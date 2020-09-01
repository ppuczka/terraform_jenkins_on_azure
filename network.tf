resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.rg_name

}

resource "azurerm_subnet" "vmsubnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefix
}

resource "azurerm_public_ip" "pip" {
  count               = var.number
  name                = "vm-ip-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "nsgname" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = var.rg_name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "PORT_SSH"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.external_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsgname.name
}

resource "azurerm_network_security_rule" "jenkins_ssl" {
  name                        = "jenkins"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = var.external_ip
  destination_address_prefix  = "*"
  resource_group_name         = var.rg_name
  network_security_group_name = azurerm_network_security_group.nsgname.name
}

#NIC with Public IP Address
resource "azurerm_network_interface" "terranic" {
  count               = var.numbercount
  name                = "vm-nic-${count.index}"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
  }

}