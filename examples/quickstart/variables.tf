variable "aks_api_server_authorized_ip_ranges" {
  description = "The list of authorized IP ranges to contact the Wayfinder Management AKS Cluster API server."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aks_rbac_aad_admin_groups" {
  description = "Map of Azure AD Groups and their Object IDs that will be set as cluster admin."
  type        = map(string)
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for AKS and the Wayfinder ingress controller."
  type        = bool
  default     = false
}

variable "dns_resource_group_name" {
  description = "The name of the resource group where the DNS Zone exists."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone to use for wayfinder."
  type        = string
}

variable "enable_k8s_resources" {
  description = "Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments)."
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment in which the resources are deployed."
  type        = string
  default     = "production"
}

variable "location" {
  description = "The Azure region in which to create the resources."
  type        = string
  default     = "uksouth"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "user_assigned_identity" {
  description = "MSI id for AKS to run as"
  type        = string
  default     = null
}

variable "wayfinder_instance_id" {
  description = "The instance ID to use for Wayfinder."
  type        = string
}

variable "wayfinder_licence_key" {
  description = "The licence key to use for Wayfinder."
  type        = string
  sensitive   = true
}
