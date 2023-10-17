module "wayfinder_cloudaccess" {
  source = "../../"

  resource_suffix                    = "app1-nonprod"
  wayfinder_identity_azure_client_id = "87654321-dcba-10fe-abcd-012345678901"
  wayfinder_identity_azure_tenant_id = "12345678-abcd-ef01-dcba-012345678901"
  enable_cluster_manager             = true
  enable_dns_zone_manager            = true
  enable_network_manager             = true
  enable_cloud_info                  = false
}
