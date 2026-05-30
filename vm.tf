resource "azurerm_network_interface" "linux_vm" {
  name                = "nic-linux-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_vm.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "vm-linux-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.linux_vm.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}