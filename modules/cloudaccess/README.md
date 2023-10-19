<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.74.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.federated_identity_aws](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_federated_identity_credential.federated_identity_gcp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_resource_group.federated_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.cloudinfo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.cloudinfo_federated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.clustermanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.clustermanager_federated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dnszonemanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.dnszonemanager_federated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.networkmanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.networkmanager_federated](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.cloudinfo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.clustermanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.dnszonemanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_role_definition.networkmanager](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) | resource |
| [azurerm_user_assigned_identity.federated_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_subscription.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_cloud_info"></a> [enable\_cloud\_info](#input\_enable\_cloud\_info) | Whether to create the Cloud Info IAM Role | `bool` | `false` | no |
| <a name="input_enable_cluster_manager"></a> [enable\_cluster\_manager](#input\_enable\_cluster\_manager) | Whether to create the Cluster Manager IAM Role | `bool` | `true` | no |
| <a name="input_enable_dns_zone_manager"></a> [enable\_dns\_zone\_manager](#input\_enable\_dns\_zone\_manager) | Whether to create the DNS Zone Manager IAM Role | `bool` | `true` | no |
| <a name="input_enable_network_manager"></a> [enable\_network\_manager](#input\_enable\_network\_manager) | Whether to create the Network Manager IAM Role | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region used for created resources (where required) | `string` | `"uksouth"` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | Suffix to apply to all generated resources. We recommend using workspace key + stage. | `string` | `""` | no |
| <a name="input_wayfinder_identity_aws_issuer"></a> [wayfinder\_identity\_aws\_issuer](#input\_wayfinder\_identity\_aws\_issuer) | Issuer URL to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA. | `string` | `""` | no |
| <a name="input_wayfinder_identity_aws_role_arn"></a> [wayfinder\_identity\_aws\_role\_arn](#input\_wayfinder\_identity\_aws\_role\_arn) | ARN of Wayfinder's identity to give access to. Populate when Wayfinder is running on AWS with IRSA. | `string` | `""` | no |
| <a name="input_wayfinder_identity_aws_subject"></a> [wayfinder\_identity\_aws\_subject](#input\_wayfinder\_identity\_aws\_subject) | Subject to trust to verify Wayfinder's AWS identity. Populate when Wayfinder is running on AWS with IRSA. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_principal_id"></a> [wayfinder\_identity\_azure\_principal\_id](#input\_wayfinder\_identity\_azure\_principal\_id) | Principal ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity or when using a credential-based Azure identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_tenant_id"></a> [wayfinder\_identity\_azure\_tenant\_id](#input\_wayfinder\_identity\_azure\_tenant\_id) | Tenant ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account"></a> [wayfinder\_identity\_gcp\_service\_account](#input\_wayfinder\_identity\_gcp\_service\_account) | Email address of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account_id"></a> [wayfinder\_identity\_gcp\_service\_account\_id](#input\_wayfinder\_identity\_gcp\_service\_account\_id) | Numerical ID of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_identity_client_id"></a> [managed\_identity\_client\_id](#output\_managed\_identity\_client\_id) | The client ID of the created managed identity to use as spec.azure.clientID in your cloud access configuration |
| <a name="output_managed_identity_principal_id"></a> [managed\_identity\_principal\_id](#output\_managed\_identity\_principal\_id) | The service principal ID of the created managed identity to use as spec.azure.principalID in your cloud access configuration |
<!-- END_TF_DOCS -->