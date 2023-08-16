controller:
  service:
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-resource-group: ${node_resource_group}
      service.beta.kubernetes.io/azure-load-balancer-internal: ${disable_internet_access}
    externalTrafficPolicy: Local
    loadBalancerIP: ${ingress_ip_address}
