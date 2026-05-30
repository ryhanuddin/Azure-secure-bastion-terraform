resource "azurerm_resource_group" "main" {
  name     = "rg-${var.prefix}-tf"
  location = var.location

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}