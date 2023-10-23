data "azurerm_subscription" "current" {}

data "azurerm_dns_zone" "wayfinder" {
  count               = var.dns_provider == "azure-private-dns" ? 0 : 1
  name                = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
}

data "azurerm_private_dns_zone" "wayfinder" {
  count               = var.dns_provider == "azure-private-dns" ? 1 : 0
  name                = var.dns_zone_name
  resource_group_name = var.dns_resource_group_name
}
