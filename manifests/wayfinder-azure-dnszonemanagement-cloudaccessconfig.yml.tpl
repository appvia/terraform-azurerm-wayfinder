apiVersion: cloudaccess.appvia.io/v2beta2
kind: CloudAccessConfig
metadata:
  name: azure-dnsmanagement
  namespace: ws-admin
spec:
  cloud: azure
  azure:
    subscription: ${subscription_id}
    tenantID: ${tenant_id}
  description: DNS zone management access, created by Wayfinder install
  type: DNSZoneManagement
  cloudIdentityRef:
    cloud: azure
    name: ${identity}
  permissions:
  - permission: DNSZoneManager
