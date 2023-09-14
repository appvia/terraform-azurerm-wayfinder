resource "azurerm_virtual_network" "wayfinder" {
  name                = "wayfinder-${var.environment}-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = data.azurerm_resource_group.wayfinder.location
  resource_group_name = data.azurerm_resource_group.wayfinder.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "aks-nodes"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = data.azurerm_resource_group.wayfinder.name
  virtual_network_name = azurerm_virtual_network.wayfinder.name
}
