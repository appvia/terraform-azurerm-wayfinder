module "wayfinder_cloudaccess" {
  source = "../../"

  resource_suffix                 = "app1-nonprod"
  wayfinder_identity_aws_role_arn = "arn:aws:iam::123456789012:role/wf-cloudidentity-aws"
  wayfinder_identity_aws_issuer   = "https://oidc.eks.eu-west-2.amazonaws.com/id/ABCDF8D2EF45CE1A6FD96E2781310123"
  wayfinder_identity_aws_subject  = "system:serviceaccount:wayfinder:wayfinder-admin"
  enable_cluster_manager          = true
  enable_dns_zone_manager         = true
  enable_network_manager          = true
  enable_cloud_info               = false
}
