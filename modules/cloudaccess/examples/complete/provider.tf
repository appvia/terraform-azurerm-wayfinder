provider "azurerm" {
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {}
}

variable "subscription_id" {
  default     = ""
  description = "The subscription ID to apply role definitions in"
  type        = string
}
