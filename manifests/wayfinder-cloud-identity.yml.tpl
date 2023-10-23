apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudIdentity
metadata:
  name: ${name}
  namespace: ws-admin
spec:
  cloud: azure
  type: AzureADWorkloadIdentity
  azure:
    clientID: ${client_id}
    tenantID: ${tenant_id}
    principalID: ${principal_id}
