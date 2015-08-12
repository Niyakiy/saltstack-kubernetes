kube-master:
  apiserver_port: 8080
  cluster_internal_net: 10.254.0.0/16
  admission_controls:
    - NamespaceLifecycle
    - NamespaceExists
    - LimitRanger
    - SecurityContextDeny
    - ResourceQuota
