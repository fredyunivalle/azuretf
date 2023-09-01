resource "azurerm_virtual_network" "azure-monitoring-vnet" {
  name                = "vnet-azure-monitoring"
  resource_group_name = azurerm_resource_group.azure-monitoring-rg.name
  location            = azurerm_resource_group.azure-monitoring-rg.location
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_network_security_group" "azure-monitoring-nsg" {
  name                = "nsg-azure-monitoring"
  location            = azurerm_resource_group.azure-monitoring-rg.location
  resource_group_name = azurerm_resource_group.azure-monitoring-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet" "azure-monitoring-subnet" {
  name                 = "subnet-azure-monitoring"
  resource_group_name  = azurerm_resource_group.azure-monitoring-rg.name
  virtual_network_name = azurerm_virtual_network.azure-monitoring-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "azure-monitoring-public-ip" {
  name                = "publicip-azure-monitoring"
  location            = azurerm_resource_group.azure-monitoring-rg.location
  resource_group_name = azurerm_resource_group.azure-monitoring-rg.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "azure-monitoring-nic" {
  name                = "nic-azure-monitoring"
  location            = azurerm_resource_group.azure-monitoring-rg.location
  resource_group_name = azurerm_resource_group.azure-monitoring-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azure-monitoring-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.azure-monitoring-public-ip.id
  }
}


resource "azurerm_linux_virtual_machine" "azure-monitoring-vm" {
  name                = "vm-azure-monitoring"
  resource_group_name = azurerm_resource_group.azure-monitoring-rg.name
  location            = azurerm_resource_group.azure-monitoring-rg.location
  size                = "Standard_B1ls"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "examplevm"
  admin_username = "adminuser"
  admin_password = "SuperSecretPassword123!"
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.azure-monitoring-nic.id]
}
