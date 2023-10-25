output "managed_identity_client_id" {
  description = "The client ID of the created managed identity to use as spec.azure.clientID in your cloud access configuration"
  value       = var.from_aws || var.from_gcp ? azurerm_user_assigned_identity.federated_identity[0].client_id : ""
}

output "managed_identity_principal_id" {
  description = "The service principal ID of the created managed identity to use as spec.azure.principalID in your cloud access configuration"
  value       = var.from_aws || var.from_gcp ? azurerm_user_assigned_identity.federated_identity[0].principal_id : ""
}
