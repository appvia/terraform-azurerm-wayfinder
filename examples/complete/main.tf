module "wayfinder" {
  source = "../../"

  aks_api_server_authorized_ip_ranges = var.aks_api_server_authorized_ip_ranges
  aks_rbac_aad_admin_group_object_ids = values(var.aks_rbac_aad_admin_groups)
  aks_vnet_subnet_id                  = var.aks_vnet_subnet_id == null ? azurerm_subnet.aks_nodes[0].id : var.aks_vnet_subnet_id
  cert_manager_keyvault_cert_name     = var.clusterissuer == "keyvault" ? coalesce(var.cert_manager_keyvault_cert_name, azurerm_key_vault_certificate.signing[0].name) : null
  cert_manager_keyvault_name          = var.clusterissuer == "keyvault" ? coalesce(var.cert_manager_keyvault_name, azurerm_key_vault.kv[0].name) : null
  clusterissuer                       = var.clusterissuer
  clusterissuer_email                 = var.clusterissuer_email
  create_localadmin_user              = var.create_localadmin_user
  disable_internet_access             = var.disable_internet_access
  disable_local_login                 = var.disable_local_login
  dns_provider                        = var.dns_provider
  dns_zone_id                         = var.dns_provider == "azure-private-dns" ? data.azurerm_private_dns_zone.wayfinder[0].id : data.azurerm_dns_zone.wayfinder[0].id
  dns_zone_name                       = var.dns_zone_name
  enable_k8s_resources                = var.enable_k8s_resources
  environment                         = var.environment
  private_dns_zone_id                 = var.private_dns_zone_id
  resource_group_name                 = var.resource_group_name
  user_assigned_identity              = coalesce(var.user_assigned_identity, azurerm_user_assigned_identity.aks_identity[0].id)
  venafi_apikey                       = var.venafi_apikey
  venafi_zone                         = var.venafi_zone
  wayfinder_domain_name_api           = "api.${var.dns_zone_name}"
  wayfinder_domain_name_ui            = "portal.${var.dns_zone_name}"
  wayfinder_idp_details               = var.wayfinder_idp_details
  wayfinder_instance_id               = var.wayfinder_instance_id
  wayfinder_licence_key               = var.wayfinder_licence_key

  depends_on = [azurerm_role_assignment.private_dns]
}
