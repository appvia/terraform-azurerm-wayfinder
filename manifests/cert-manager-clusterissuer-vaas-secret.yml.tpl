apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: vaas-secret
  namespace: cert-manager
stringData:
  apikey: ${venafi_apikey}