apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME production server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: ${email}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - dns01:
        azureDNS:
          hostedZoneName: ${dns_zone_name}
          resourceGroupName: ${resource_group}
          subscriptionID: ${subscription_id}
          environment: AzurePublicCloud
          managedIdentity:
            clientID: ${identity_client_id}
