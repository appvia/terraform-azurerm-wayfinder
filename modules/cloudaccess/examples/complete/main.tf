module "wayfinder_cloudaccess" {
  source = "github.com/appvia/terraform-azurerm-wayfinder//modules/cloudaccess?ref=v3"

  resource_suffix = var.resource_suffix
  region          = var.region

  wayfinder_identity_azure_principal_id     = var.wayfinder_identity_azure_principal_id
  wayfinder_identity_aws_issuer             = var.wayfinder_identity_aws_issuer
  wayfinder_identity_aws_subject            = var.wayfinder_identity_aws_subject
  wayfinder_identity_gcp_service_account_id = var.wayfinder_identity_gcp_service_account_id

  enable_cluster_manager_permissions      = var.enable_cluster_manager
  enable_dns_zone_manager_permissions     = var.enable_dns_zone_manager
  enable_network_manager_permissions      = var.enable_network_manager
  enable_cloud_info_permissions           = var.enable_cloud_info
  enable_peering_acceptor_permissions     = var.enable_peering_acceptor
  enable_private_link_manager_permissions = var.enable_private_link_manager
  custom_roles                           = var.custom_roles

  from_aws   = var.from_aws
  from_azure = var.from_azure
  from_gcp   = var.from_gcp
}
