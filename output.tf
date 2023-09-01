output "azure_monitoring_vm_public_ip" {
  value       = azurerm_public_ip.azure-monitoring-public-ip.ip_address
  description = "The public IP address of the Azure monitoring VM."
}

