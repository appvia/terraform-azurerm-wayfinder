variable "aks_api_server_authorized_ip_ranges" {
  description = "The list of authorized IP ranges to contact the Wayfinder Management AKS Cluster API server."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aks_rbac_aad_admin_groups" {
  description = "Map of Azure AD Groups and their Object IDs that will be set as cluster admin."
  type        = map(string)
}

variable "aks_vnet_subnet_id" {
  description = "The ID of the subnet in which to deploy the Kubernetes Cluster."
  type        = string
  default     = null
}

variable "clusterissuer" {
  description = "Cluster Issuer name to use for certs"
  type        = string
  default     = "letsencrypt-prod"
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "create_localadmin_user" {
  description = "Whether to create a localadmin user for access to the Wayfinder Portal and API."
  type        = bool
  default     = false
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for AKS and the Wayfinder ingress controller."
  type        = bool
  default     = false
}

variable "disable_local_login" {
  description = "Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in."
  type        = bool
  default     = false
}

variable "dns_provider" {
  description = "DNS provider to for External DNS"
  type        = string
  default     = "azure"
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

variable "private_dns_zone_id" {
  description = "Private DNS zone to use for private clusters"
  type        = string
  default     = null
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

variable "venafi_apikey" {
  description = "Venafi API key - required if using Venafi cluster issuer"
  type        = string
  default     = ""
}

variable "venafi_zone" {
  description = "Venafi zone - required if using Venafi cluster issuer"
  type        = string
  default     = ""
}

variable "wayfinder_idp_details" {
  description = "The IDP details to use for Wayfinder to enable SSO."
  type = object({
    type          = string
    clientId      = string
    clientSecret  = string
    serverUrl     = optional(string)
    azureTenantId = optional(string)
  })

  sensitive = true

  validation {
    condition     = contains(["generic", "aad"], var.wayfinder_idp_details["type"])
    error_message = "wayfinder_idp_details[\"type\"] must be one of: generic, aad"
  }

  validation {
    condition     = (var.wayfinder_idp_details["type"] == "generic" && length(var.wayfinder_idp_details["serverUrl"]) > 0) || (var.wayfinder_idp_details["type"] == "aad" && length(var.wayfinder_idp_details["azureTenantId"]) > 0)
    error_message = "serverUrl must be set if IDP type is generic, azureTenantId must be set if IDP type is aad"
  }
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
