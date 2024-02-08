resource "azurerm_resource_group" "demo" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "demo" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "demo" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "demo" {
  name                = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  resource_group_name         = azurerm_resource_group.demo.name
  network_security_group_name = azurerm_network_security_group.demo.name
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "demo" {
  subnet_id                 = azurerm_subnet.demo.id
  network_security_group_id = azurerm_network_security_group.demo.id
}


resource "azurerm_network_interface" "demo" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = azurerm_resource_group.demo.location
  size                            = "Standard_B2s"
  admin_username                  = "adminuser"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.demo.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"

    diff_disk_settings {
      option = "Local"
    }
  }
}