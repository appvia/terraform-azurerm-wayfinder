resource "azurerm_resource_group" "federated_identity" {
  count = var.from_aws || var.from_gcp ? 1 : 0

  name     = "${local.resource_prefix}federated-id${local.resource_suffix}"
  location = var.region
}

resource "azurerm_user_assigned_identity" "federated_identity" {
  count = var.from_aws || var.from_gcp ? 1 : 0

  location            = azurerm_resource_group.federated_identity[0].location
  name                = "${local.resource_prefix}federated-id${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.federated_identity[0].name
}

resource "azurerm_federated_identity_credential" "federated_identity_aws" {
  count = var.from_aws ? 1 : 0

  name                = "${local.resource_prefix}federated-id-aws${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.federated_identity[0].name
  parent_id           = azurerm_user_assigned_identity.federated_identity[0].id
  issuer              = var.wayfinder_identity_aws_issuer
  audience            = ["sts.amazonaws.com"]
  subject             = var.wayfinder_identity_aws_subject

  lifecycle {
    precondition {
      condition     = var.wayfinder_identity_aws_issuer != "" || var.wayfinder_identity_aws_subject != ""
      error_message = "Must specify wayfinder_identity_aws_issuer and wayfinder_identity_aws_subject to enable cross-cloud trust from AWS to Azure"
    }
  }
}

resource "azurerm_federated_identity_credential" "federated_identity_gcp" {
  count = var.from_gcp ? 1 : 0

  name                = "${local.resource_prefix}federated-id-gcp${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.federated_identity[0].name
  parent_id           = azurerm_user_assigned_identity.federated_identity[0].id
  issuer              = "https://accounts.google.com"
  audience            = ["gtoken/sts/assume"]
  subject             = var.wayfinder_identity_gcp_service_account_id

  lifecycle {
    precondition {
      condition     = var.wayfinder_identity_gcp_service_account_id != ""
      error_message = "Must specify numerical ID of the GCP service account to trust in wayfinder_identity_gcp_service_account_id"
    }
  }
}
