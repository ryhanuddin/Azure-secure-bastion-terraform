resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_monitor_data_collection_rule" "vm_performance" {
  name                = "dcr-vm-performance-${var.prefix}-tf"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.main.id
      name                  = "log-analytics-destination"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["log-analytics-destination"]
  }

  data_sources {
    performance_counter {
      name                          = "linux-vm-performance-counters"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60

      counter_specifiers = [
        "\\Processor(_Total)\\% Processor Time",
        "\\Memory\\Available MBytes",
        "\\LogicalDisk(_Total)\\% Free Space",
        "\\Network Interface(*)\\Bytes Total/sec"
      ]
    }
  }

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.main.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  tags = {
    project     = "secure-azure-bastion-terraform"
    environment = "lab"
    managed_by  = "terraform"
  }
}

resource "azurerm_monitor_data_collection_rule_association" "vm_performance" {
  name                    = "dcra-vm-performance-${var.prefix}-tf"
  target_resource_id      = azurerm_linux_virtual_machine.main.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vm_performance.id
}