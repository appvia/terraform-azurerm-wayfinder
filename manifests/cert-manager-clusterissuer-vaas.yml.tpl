apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: vaas-issuer
spec:
  venafi:
    zone: ${venafi_zone}
    cloud:
      apiTokenSecretRef:
        name: vaas-secret
        namespace: cert-manager
        key: apikey
