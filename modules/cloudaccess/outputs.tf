output "managed_identity_client_id" {
  description = "The client ID of the created managed identity to use as spec.azure.clientID in your cloud access configuration"
  value       = var.from_aws || var.from_gcp ? azurerm_user_assigned_identity.federated_identity[0].client_id : ""
}

output "managed_identity_tenant_id" {
  description = "The tenant ID in which the managed identity exists, to use as spec.azure.tenantID in your cloud access configuration"
  value       = var.from_aws || var.from_gcp ? data.azurerm_subscription.primary.tenant_id : ""
}
