locals {
  resource_prefix = "wf-"
  resource_suffix = var.resource_suffix

  create_aws_trust = var.wayfinder_identity_aws_role_arn != "" ? true : false
  create_gcp_trust = var.wayfinder_identity_gcp_service_account != "" ? true : false
}

data "azurerm_subscription" "primary" {
}
