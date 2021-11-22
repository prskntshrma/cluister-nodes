resource "azurerm_public_ip" "pip" {
  allocation_method   = "Dynamic"
  location            = var.location
  resource_group_name = var.rgname
  name                = "${var.prefix}-pip"

}
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.rgname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.prefix
  resource_group_name = var.rgname
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "paras"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "paras"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
