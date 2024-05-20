module "wayfinder" {
  source = "../../"

  aks_api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  aks_rbac_aad_admin_group_object_ids = values(var.aks_rbac_aad_admin_groups)
  aks_vnet_subnet_id                  = azurerm_subnet.aks_nodes.id
  clusterissuer_email                 = var.clusterissuer_email
  create_localadmin_user              = true
  disable_internet_access             = var.disable_internet_access
  dns_zone_id                         = data.azurerm_dns_zone.wayfinder.id
  dns_zone_name                       = var.dns_zone_name
  enable_k8s_resources                = var.enable_k8s_resources
  environment                         = var.environment
  resource_group_name                 = var.resource_group_name
  wayfinder_domain_name_api           = "api.${var.dns_zone_name}"
  wayfinder_domain_name_ui            = "portal.${var.dns_zone_name}"
  wayfinder_instance_id               = var.wayfinder_instance_id
  wayfinder_licence_key               = var.wayfinder_licence_key
  user_assigned_identity              = var.user_assigned_identity

}
