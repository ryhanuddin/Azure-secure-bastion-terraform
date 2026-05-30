resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}