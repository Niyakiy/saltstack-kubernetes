base:
  'roles:etcd-server':
    - match: grain
    - etcd

  'G@roles:kube-master or G@roles:kube-node':
    - match: compound
    - kube-common

  'roles:kube-master':
    - match: grain
    - kube-master

  'roles:kube-node':
    - match: grain
    - kube-node
