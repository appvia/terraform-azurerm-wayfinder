module "wayfinder_cloudaccess" {
  source = "github.com/appvia/terraform-azurerm-wayfinder//modules/cloudaccess"

  resource_suffix = var.resource_suffix
  region          = var.region

  wayfinder_identity_azure_principal_id     = var.wayfinder_identity_azure_principal_id
  wayfinder_identity_aws_issuer             = var.wayfinder_identity_aws_issuer
  wayfinder_identity_aws_subject            = var.wayfinder_identity_aws_subject
  wayfinder_identity_gcp_service_account_id = var.wayfinder_identity_gcp_service_account_id

  enable_cluster_manager  = var.enable_cluster_manager
  enable_dns_zone_manager = var.enable_dns_zone_manager
  enable_network_manager  = var.enable_network_manager
  enable_cloud_info       = var.enable_cloud_info
  enable_peering_acceptor = var.enable_peering_acceptor

  from_aws   = var.from_aws
  from_azure = var.from_azure
  from_gcp   = var.from_gcp
}
