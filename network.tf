resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = azurerm_resource_group.devops_rg.name
}

resource "azurerm_subnet" "vmsubnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.devops_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefix
}

resource "azurerm_public_ip" "ip-1" {
  # count               = var.numbercount
  name                = "vm-ip-1"
  resource_group_name = azurerm_resource_group.devops_rg.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_public_ip" "ip-2" {
  # count               = var.numbercount
  name                = "vm-ip-2"
  resource_group_name = azurerm_resource_group.devops_rg.name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "nsgname" {
  name                = "vm-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops_rg.name

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
  resource_group_name         = azurerm_resource_group.devops_rg.name
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
  resource_group_name         = azurerm_resource_group.devops_rg.name
  network_security_group_name = azurerm_network_security_group.nsgname.name
}

#NIC with Public IP Address
resource "azurerm_network_interface" "terranic-1" {
  # count               = var.numbercount
  name                = "vm-nic-1"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops_rg.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-1.id
  }

}
#NIC with Public IP Address
resource "azurerm_network_interface" "terranic-2" {
  # count               = var.numbercount
  name                = "vm-nic-2"
  location            = var.location
  resource_group_name = azurerm_resource_group.devops_rg.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-2.id

  }
}
