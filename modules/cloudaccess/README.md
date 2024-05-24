<!-- BEGIN_TF_DOCS -->
# Terraform Module: Cloud Access for Wayfinder on Azure

This Terraform Module can be used to associate Roles to Wayfinder's Azure Identity, for creating resources within an Azure Subscription.

**Notes:**
* You must set `var.wayfinder_identity_azure_principal_id` to the Azure Principal ID of the Wayfinder Identity.
* `var.resource_suffix` is an optional suffix to use on created objects. We recommend using workspace key + stage if you wish to have multiple workspaces sharing the same AWS account, allowing independent roles to be provisioned for each.

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_duration_delay"></a> [create\_duration\_delay](#input\_create\_duration\_delay) | Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type. | <pre>object({<br>    azurerm_role_definition = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_destroy_duration_delay"></a> [destroy\_duration\_delay](#input\_destroy\_duration\_delay) | Used to tune terraform destroy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type. | <pre>object({<br>    azurerm_role_definition = optional(string, "0s")<br>  })</pre> | `{}` | no |
| <a name="input_enable_cloud_info"></a> [enable\_cloud\_info](#input\_enable\_cloud\_info) | Whether to create the Cloud Info IAM Role | `bool` | `false` | no |
| <a name="input_enable_cluster_manager"></a> [enable\_cluster\_manager](#input\_enable\_cluster\_manager) | Whether to create the Cluster Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_dns_zone_manager"></a> [enable\_dns\_zone\_manager](#input\_enable\_dns\_zone\_manager) | Whether to create the DNS Zone Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_network_manager"></a> [enable\_network\_manager](#input\_enable\_network\_manager) | Whether to create the Network Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_peering_acceptor"></a> [enable\_peering\_acceptor](#input\_enable\_peering\_acceptor) | Whether to create the Peering Acceptor IAM Role | `bool` | `false` | no |
| <a name="input_from_aws"></a> [from\_aws](#input\_from\_aws) | Whether Wayfinder is running on AWS. | `bool` | `false` | no |
| <a name="input_from_azure"></a> [from\_azure](#input\_from\_azure) | Whether Wayfinder is running on Azure. | `bool` | `true` | no |
| <a name="input_from_gcp"></a> [from\_gcp](#input\_from\_gcp) | Whether Wayfinder is running on GCP. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | The region used for created resources (where required) | `string` | `"uksouth"` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | Suffix to apply to all generated resources. We recommend using workspace key + stage. | `string` | `""` | no |
| <a name="input_wayfinder_identity_aws_issuer"></a> [wayfinder\_identity\_aws\_issuer](#input\_wayfinder\_identity\_aws\_issuer) | Issuer URL to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA. | `string` | `""` | no |
| <a name="input_wayfinder_identity_aws_subject"></a> [wayfinder\_identity\_aws\_subject](#input\_wayfinder\_identity\_aws\_subject) | Subject to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_principal_id"></a> [wayfinder\_identity\_azure\_principal\_id](#input\_wayfinder\_identity\_azure\_principal\_id) | Principal ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity or when using a credential-based Azure identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account_id"></a> [wayfinder\_identity\_gcp\_service\_account\_id](#input\_wayfinder\_identity\_gcp\_service\_account\_id) | Numerical ID of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_identity_client_id"></a> [managed\_identity\_client\_id](#output\_managed\_identity\_client\_id) | The client ID of the created managed identity to use as spec.azure.clientID in your cloud access configuration |
| <a name="output_managed_identity_tenant_id"></a> [managed\_identity\_tenant\_id](#output\_managed\_identity\_tenant\_id) | The tenant ID in which the managed identity exists, to use as spec.azure.tenantID in your cloud access configuration |

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`
<!-- END_TF_DOCS -->