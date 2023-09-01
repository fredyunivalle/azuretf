resource "azurerm_resource_group" "azure-monitoring-rg" {
  name     = "rg-azure-monitoring"
  location = local.region
  tags     = local.default_tags
}