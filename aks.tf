#tfsec:ignore:azure-container-limit-authorized-ips
module "aks" {
  source  = "Azure/aks/azurerm"
  version = "7.3.1"

  prefix              = local.name
  resource_group_name = var.resource_group_name

  agents_availability_zones             = ["1", "2", "3"]
  agents_count                          = null
  agents_max_count                      = 10
  agents_max_pods                       = 50
  agents_min_count                      = 2
  agents_pool_name                      = "compute"
  agents_size                           = var.aks_agents_size
  agents_tags                           = local.tags
  agents_type                           = "VirtualMachineScaleSets"
  api_server_authorized_ip_ranges       = !var.disable_internet_access ? var.aks_api_server_authorized_ip_ranges : null
  auto_scaler_profile_enabled           = true
  auto_scaler_profile_max_unready_nodes = 1
  automatic_channel_upgrade             = "patch"
  azure_policy_enabled                  = true
  enable_auto_scaling                   = true
  enable_host_encryption                = var.aks_enable_host_encryption
  key_vault_secrets_provider_enabled    = var.clusterissuer == "keyvault" ? true : false
  kubernetes_version                    = var.cluster_version
  maintenance_window                    = var.aks_maintenance_window
  net_profile_dns_service_ip            = "192.168.100.10"
  net_profile_service_cidr              = "192.168.100.0/24"
  network_plugin                        = "azure"
  network_plugin_mode                   = "overlay"
  network_policy                        = "calico"
  oidc_issuer_enabled                   = true
  orchestrator_version                  = var.cluster_nodepool_version
  os_disk_size_gb                       = 50
  os_disk_type                          = "Ephemeral"
  os_sku                                = "Ubuntu"
  net_profile_outbound_type             = var.disable_internet_access == true ? "userDefinedRouting" : "loadBalancer"
  private_cluster_enabled               = var.disable_internet_access
  private_cluster_public_fqdn_enabled   = false
  private_dns_zone_id                   = var.private_dns_zone_id
  public_network_access_enabled         = !var.disable_internet_access
  rbac_aad                              = true
  rbac_aad_admin_group_object_ids       = var.aks_rbac_aad_admin_group_object_ids
  rbac_aad_managed                      = true
  role_based_access_control_enabled     = true
  sku_tier                              = var.aks_sku_tier
  storage_profile_disk_driver_enabled   = true
  storage_profile_disk_driver_version   = "v1"
  tags                                  = local.tags
  vnet_subnet_id                        = var.aks_vnet_subnet_id
  identity_ids                          = [var.user_assigned_identity]
  identity_type                         = "UserAssigned"
  workload_identity_enabled             = true

  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [
        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]

  network_contributor_role_assigned_subnet_ids = {
    vnet_subnet = var.aks_vnet_subnet_id
  }
}
