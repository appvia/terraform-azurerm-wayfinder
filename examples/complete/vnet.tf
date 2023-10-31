resource "azurerm_virtual_network" "wayfinder" {
  count               = var.aks_vnet_subnet_id == null ? 1 : 0
  name                = "wayfinder-${var.environment}-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_nodes" {
  count                = var.aks_vnet_subnet_id == null ? 1 : 0
  name                 = "aks-nodes"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.wayfinder[0].name
}
