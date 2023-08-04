apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: azure-config-file
  namespace: external-dns
stringData:
  azure.json: |-
    {
      "tenantId": "${tenant_id}",
      "subscriptionId": "${subscription_id}",
      "resourceGroup": "${resource_group}",
      "userAssignedIdentityID": "${user_assigned_identity_id}",
      "useManagedIdentityExtension": true
    }
