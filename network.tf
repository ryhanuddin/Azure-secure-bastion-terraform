resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.prefix}-tf"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.1.0/26"]
}

resource "azurerm_subnet" "private_vm" {
  name                 = "snet-private-vm-${var.prefix}-tf"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_network_security_group" "private_vm" {
  name                = "nsg-private-vm-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "private_vm" {
  subnet_id                 = azurerm_subnet.private_vm.id
  network_security_group_id = azurerm_network_security_group.private_vm.id
}