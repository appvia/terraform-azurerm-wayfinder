resource "azurerm_virtual_network" "wayfinder" {
  count               = var.aks_vnet_subnet_id == null ? 1 : 0
  name                = "wayfinder-${var.environment}-vnet"
  address_space       = ["10.0.0.0/22"]
  location            = data.azurerm_resource_group.wayfinder.location
  resource_group_name = data.azurerm_resource_group.wayfinder.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks_nodes" {
  count                = var.aks_vnet_subnet_id == null ? 1 : 0
  name                 = "aks-nodes"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = data.azurerm_resource_group.wayfinder.name
  virtual_network_name = azurerm_virtual_network.wayfinder[0].name
}

module "wayfinder" {
  source = "../../"

  aks_api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  aks_rbac_aad_admin_group_object_ids = values(var.aks_rbac_aad_admin_groups)
  aks_vnet_subnet_id                  = var.aks_vnet_subnet_id == null ? azurerm_subnet.aks_nodes[0].id : var.aks_vnet_subnet_id
  clusterissuer                       = var.clusterissuer
  clusterissuer_email                 = var.clusterissuer_email
  disable_internet_access             = var.disable_internet_access
  dns_provider                        = var.dns_provider
  dns_zone_id                         = var.dns_provider == "azure-private-dns" ? data.azurerm_private_dns_zone.wayfinder[0].id : data.azurerm_dns_zone.wayfinder[0].id
  dns_zone_name                       = var.dns_zone_name
  enable_k8s_resources                = var.enable_k8s_resources
  environment                         = var.environment
  private_dns_zone_id                 = var.private_dns_zone_id
  resource_group_id                   = data.azurerm_resource_group.wayfinder.id
  resource_group_name                 = data.azurerm_resource_group.wayfinder.name
  user_assigned_identity              = var.user_assigned_identity
  venafi_apikey                       = var.venafi_apikey
  venafi_zone                         = var.venafi_zone
  wayfinder_domain_name_api           = "api.${var.dns_zone_name}"
  wayfinder_domain_name_ui            = "portal.${var.dns_zone_name}"
  wayfinder_idp_details               = var.wayfinder_idp_details
  wayfinder_license_key               = var.wayfinder_license_key
  wayfinder_instance_id               = var.wayfinder_instance_id
}
