variable "aks_agents_size" {
  description = "The default size of the agents pool."
  type        = string
  default     = "Standard_D2s_v3"
}

variable "aks_api_server_authorized_ip_ranges" {
  description = "The list of authorized IP ranges to contact the API server."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "aks_enable_host_encryption" {
  description = "Whether to enable host encryption."
  type        = bool
  default     = false
}

variable "aks_maintenance_window" {
  type = object({
    allowed = list(object({
      day   = string
      hours = set(number)
    })),
    not_allowed = list(object({
      end   = string
      start = string
    })),
  })
  description = "Maintenance configuration of the managed cluster."
  default = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ],
    not_allowed = []
  }
}

variable "aks_rbac_aad_admin_group_object_ids" {
  description = "List of object IDs of the Azure AD groups that will be set as cluster admin."
  type        = list(string)
  default     = []
}

variable "aks_sku_tier" {
  description = "The SKU tier for this Kubernetes Cluster."
  type        = string
  default     = "Standard"
}

variable "aks_vnet_subnet_id" {
  description = "The ID of the subnet in which to deploy the Kubernetes Cluster."
  type        = string
}

variable "cert_manager_keyvault_name" {
  description = "Keyvault name to use for cert-manager. Required if cluster issuer is keyvault"
  type        = string
  default     = null
}

variable "cert_manager_keyvault_cert_name" {
  description = "Keyvault certificate name to use for cert-manager. Required if cluster issuer is keyvault"
  type        = string
  default     = null
}

variable "clusterissuer" {
  description = "Cluster Issuer name to use for certs"
  type        = string
  default     = "letsencrypt-prod"
  validation {
    condition     = contains(["letsencrypt-prod", "vaas-issuer", "keyvault"], var.clusterissuer)
    error_message = "clusterissuer must be one of: letsencrypt-prod, vaas-issuer, keyvault"
  }
}

variable "clusterissuer_email" {
  description = "The email address to use for the cert-manager cluster issuer."
  type        = string
}

variable "create_duration_delay" {
  type = object({
    azurerm_role_definition         = optional(string, "180s")
    kubectl_manifest_cloud_identity = optional(string, "30s")
  })
  description = "Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type."
  default     = {}

  validation {
    condition     = can([for v in values(var.create_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The create_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "create_localadmin_user" {
  description = "Whether to create a localadmin user for access to the Wayfinder Portal and API"
  type        = bool
  default     = true
}

variable "destroy_duration_delay" {
  type = object({
    azurerm_role_definition         = optional(string, "0s")
    kubectl_manifest_cloud_identity = optional(string, "60s")
  })
  description = "Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type."
  default     = {}

  validation {
    condition     = can([for v in values(var.destroy_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The destroy_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "disable_internet_access" {
  description = "Whether to disable internet access for AKS and the Wayfinder ingress controller"
  type        = bool
  default     = false
}

variable "dns_provider" {
  description = "DNS provider for External DNS"
  type        = string
  default     = "azure"
}

variable "disable_local_login" {
  description = "Whether to disable local login for Wayfinder. Note: An IDP must be configured within Wayfinder, otherwise you will not be able to log in."
  type        = bool
  default     = false
}

variable "dns_zone_id" {
  description = "The ID of the Azure DNS Zone to use."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the Azure DNS zone to use."
  type        = string
}

variable "enable_k8s_resources" {
  description = "Whether to enable the creation of Kubernetes resources for Wayfinder (helm and kubectl manifest deployments)"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment in which the resources are deployed."
  type        = string
  default     = "production"
}

variable "location" {
  description = "The Azure region to use."
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
  description = "A mapping of tags to assign to resources."
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
  sensitive   = true
}

variable "venafi_zone" {
  description = "Venafi zone - required if using Venafi cluster issuer"
  type        = string
  default     = ""
}

variable "wayfinder_domain_name_api" {
  description = "The domain name to use for the Wayfinder API (e.g. api.wayfinder.example.com)"
  type        = string
}

variable "wayfinder_domain_name_ui" {
  description = "The domain name to use for the Wayfinder UI (e.g. portal.wayfinder.example.com)"
  type        = string
}

variable "wayfinder_idp_details" {
  description = "The IDP details to use for Wayfinder to enable SSO"
  type = object({
    type          = string
    clientId      = optional(string)
    clientSecret  = optional(string)
    serverUrl     = optional(string)
    azureTenantId = optional(string)
  })

  sensitive = true

  validation {
    condition     = contains(["generic", "aad", "none"], var.wayfinder_idp_details["type"])
    error_message = "wayfinder_idp_details[\"type\"] must be one of: generic, aad, none"
  }

  validation {
    condition     = var.wayfinder_idp_details["type"] == "none" || (var.wayfinder_idp_details["type"] == "generic" && length(var.wayfinder_idp_details["serverUrl"]) > 0) || (var.wayfinder_idp_details["type"] == "aad" && length(var.wayfinder_idp_details["azureTenantId"]) > 0)
    error_message = "serverUrl must be set if IDP type is generic, azureTenantId must be set if IDP type is aad"
  }

  default = {
    type          = "none"
    clientId      = null
    clientSecret  = null
    serverUrl     = ""
    azureTenantId = ""
  }
}

variable "wayfinder_instance_id" {
  description = "The instance ID to use for Wayfinder."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{20}$", var.wayfinder_instance_id))
    error_message = "The Wayfinder Instance ID must be alphanumeric and 20 characters long."
  }
}

variable "wayfinder_licence_key" {
  description = "The licence key to use for Wayfinder"
  type        = string
  sensitive   = true
}

variable "wayfinder_release_channel" {
  description = "The release channel to use for Wayfinder"
  type        = string
  default     = "wayfinder-releases"
}

variable "wayfinder_version" {
  description = "The version to use for Wayfinder"
  type        = string
  default     = "v2.3.3"
}
