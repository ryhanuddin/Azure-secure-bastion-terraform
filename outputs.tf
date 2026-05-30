output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "bastion_host_name" {
  description = "Name of the Azure Bastion host"
  value       = azurerm_bastion_host.main.name
}

output "linux_vm_name" {
  description = "Name of the private Linux VM"
  value       = azurerm_linux_virtual_machine.main.name
}

output "linux_vm_private_ip" {
  description = "Private IP address of the Linux VM"
  value       = azurerm_network_interface.linux_vm.private_ip_address
}

output "nat_gateway_public_ip" {
  description = "Public IP address used by NAT Gateway for outbound internet"
  value       = azurerm_public_ip.nat.ip_address
}

output "bastion_public_ip" {
  description = "Public IP address of Azure Bastion"
  value       = azurerm_public_ip.bastion.ip_address
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.name
}