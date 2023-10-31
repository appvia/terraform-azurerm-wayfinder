apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: keyvault
spec:
  ca:
    secretName: keyvault-issuer
