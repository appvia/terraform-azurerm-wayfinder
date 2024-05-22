api:
  enabled: true
  endpoint:
    url: "https://${api_hostname}"
  ingress:
    enabled: true
    hostname: "${api_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ingress-api-tls"
    annotations:
      cert-manager.io/cluster-issuer: ${clusterissuer}
      cert-manager.io/issuer-kind: ${issuerkind}
      cert-manager.io/issuer-group: ${issuergroup}
      cert-manager.io/common-name: ${api_hostname}
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
      nginx.ingress.kubernetes.io/proxy-buffer-size: '16k'
    namespace: "ingress-nginx"
    className: "nginx"
  wayfinderInstanceIdentifier: "${wayfinder_instance_identifier}"
disableLocalLogin: ${disable_local_login}
enableLocalAdminUser: ${enable_localadmin_user}
mysql:
  pvc:
    storageClass: "${storage_class}"
ui:
  cloudOrder: "['azure','aws','gcp']"
  enabled: true
  endpoint:
    url: "https://${ui_hostname}"
  ingress:
    enabled: true
    hostname: "${ui_hostname}"
    tlsEnabled: true
    tlsSecret: "wayfinder-ingress-ui-tls"
    annotations:
      cert-manager.io/cluster-issuer: ${clusterissuer}
      cert-manager.io/issuer-kind: ${issuerkind}
      cert-manager.io/issuer-group: ${issuergroup}
      cert-manager.io/common-name: ${ui_hostname}
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    namespace: "ingress-nginx"
    className: "nginx"
workloadIdentity:
  azure:
    clientID: ${wayfinder_client_id}
