output "cluster_name" {
  description = "The name of the Wayfinder AKS cluster"
  value       = module.wayfinder.cluster_name
}

output "wayfinder_api_url" {
  description = "The URL for the Wayfinder API"
  value       = module.wayfinder.wayfinder_api_url
}

output "wayfinder_ui_url" {
  description = "The URL for the Wayfinder UI"
  value       = module.wayfinder.wayfinder_ui_url
}

output "wayfinder_instance_id" {
  description = "The unique identifier for the Wayfinder instance"
  value       = module.wayfinder.wayfinder_instance_id
}
