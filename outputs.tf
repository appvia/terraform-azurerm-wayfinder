output "aks_client_certificate" {
  description = "The `client_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block.  Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.admin_client_certificate
}

output "aks_client_key" {
  description = "The `client_key` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded private key used by clients to authenticate to the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.admin_client_key
}

output "aks_cluster_ca_certificate" {
  description = "The `cluster_ca_certificate` in the `azurerm_kubernetes_cluster`'s `kube_admin_config` block. Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster."
  sensitive   = true
  value       = module.aks.admin_cluster_ca_certificate
}

output "aks_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  sensitive   = true
  value       = module.aks.cluster_fqdn
}

output "aks_host" {
  description = "The Kubernetes cluster server host. This is a Private Link address if 'disable_internet_access' is configured."
  sensitive   = true
  value       = module.aks.admin_host
}

output "cluster_name" {
  description = "The name of the Wayfinder AKS cluster"
  value       = module.aks.aks_name
}

output "wayfinder_api_url" {
  description = "The URL for the Wayfinder API"
  value       = "https://${var.wayfinder_domain_name_api}"
}

output "wayfinder_ui_url" {
  description = "The URL for the Wayfinder UI"
  value       = "https://${var.wayfinder_domain_name_ui}"
}

output "wayfinder_instance_id" {
  description = "The unique identifier for the Wayfinder instance"
  value       = local.wayfinder_instance_id
}
