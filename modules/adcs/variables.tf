variable "adcs_url" {
  type        = string
  description = "URL of the ADCS web UI"
}

variable "username" {
  type        = string
  description = "Username of the identity that will authenticate with ADCS to request certificates"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Password of the identity that will authenticate with ADCS to request certificates"
}

variable "adcs_ca_bundle" {
  type        = string
  description = "Base64 encoded ca bundle for communication with ADCS.  Can be obtained with 'cat bundle.pem | base64 -w 0'"
}

variable "certificate_template_name" {
  type        = string
  description = "ADCS certificate template name to use for signing."
}
