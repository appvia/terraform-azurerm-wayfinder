module "wayfinder_cloudaccess" {
  source = "../../"

  resource_suffix = var.resource_suffix
  region          = var.region

  wayfinder_identity_azure_principal_id     = var.wayfinder_identity_azure_principal_id
  wayfinder_identity_azure_tenant_id        = var.wayfinder_identity_azure_tenant_id
  wayfinder_identity_aws_role_arn           = var.wayfinder_identity_aws_role_arn
  wayfinder_identity_aws_issuer             = var.wayfinder_identity_aws_issuer
  wayfinder_identity_aws_subject            = var.wayfinder_identity_aws_subject
  wayfinder_identity_gcp_service_account    = var.wayfinder_identity_gcp_service_account
  wayfinder_identity_gcp_service_account_id = var.wayfinder_identity_gcp_service_account_id

  enable_cluster_manager  = var.enable_cluster_manager
  enable_dns_zone_manager = var.enable_dns_zone_manager
  enable_network_manager  = var.enable_network_manager
  enable_cloud_info       = var.enable_cloud_info
}
