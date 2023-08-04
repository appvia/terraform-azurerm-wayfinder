apiVersion: cloudaccess.appvia.io/v2beta1
kind: CloudAccessConfig
metadata:
  name: azure-admin
  namespace: ws-admin
spec:
  cloud: azure
  defaultRegion: ${region}
  description: Wayfinder management cluster cloud access, created by Wayfinder install
  features:
  - DNSZoneManagement
  - CostsEstimates
  identifier: ${subscription_id}
  identityCred:
    name: azure-admin-none
    namespace: ws-admin
  name: azure-admin
  roles:
  - assumeProviderRole: azure-admin-dnszonemanager
    cloudResourceName: ${dns_zone_manager_identity}
    role: DNSZoneManager
  - assumeProviderRole: azure-admin-none
    cloudResourceName: ${none_identity}
    role: None
  - assumeProviderRole: azure-admin-cloudinfo
    cloudResourceName: ${cloud_info_identity}
    role: CloudInfo
