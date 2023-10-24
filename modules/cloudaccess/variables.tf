variable "resource_suffix" {
  default     = ""
  description = "Suffix to apply to all generated resources. We recommend using workspace key + stage."
  type        = string
}

variable "wayfinder_identity_azure_principal_id" {
  default     = ""
  description = "Principal ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity or when using a credential-based Azure identity."
  type        = string
}

variable "wayfinder_identity_azure_tenant_id" {
  default     = ""
  description = "Tenant ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity."
  type        = string
}

variable "wayfinder_identity_aws_role_arn" {
  default     = ""
  description = "ARN of Wayfinder's identity to give access to. Populate when Wayfinder is running on AWS with IRSA."
  type        = string
}

variable "wayfinder_identity_aws_issuer" {
  default     = ""
  description = "Issuer URL to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA."
  type        = string
}

variable "wayfinder_identity_aws_subject" {
  default     = ""
  description = "Subject to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA."
  type        = string
}

variable "wayfinder_identity_gcp_service_account" {
  default     = ""
  description = "Email address of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity."
  type        = string
}

variable "wayfinder_identity_gcp_service_account_id" {
  default     = ""
  description = "Numerical ID of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity."
  type        = string
}

variable "region" {
  default     = "uksouth"
  description = "The region used for created resources (where required)"
  type        = string
}

variable "enable_cluster_manager" {
  default     = true
  description = "Whether to create the Cluster Manager IAM Role"
  type        = bool
}

variable "enable_dns_zone_manager" {
  default     = true
  description = "Whether to create the DNS Zone Manager IAM Role"
  type        = bool
}

variable "enable_network_manager" {
  default     = true
  description = "Whether to create the Network Manager IAM Role"
  type        = bool
}

variable "enable_cloud_info" {
  default     = false
  description = "Whether to create the Cloud Info IAM Role"
  type        = bool
}

variable "create_duration_delay" {
  type = object({
    azurerm_role_definition = optional(string, "30s")
  })
  description = "Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type."
  default     = {}

  validation {
    condition     = can([for v in values(var.create_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The create_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "destroy_duration_delay" {
  type = object({
    azurerm_role_definition = optional(string, "0s")
  })
  description = "Used to tune terraform destroy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type."
  default     = {}

  validation {
    condition     = can([for v in values(var.destroy_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The destroy_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}
