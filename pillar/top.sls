base:
  'roles:etcd-server':
    - match: grain
    - etcd

  'G@roles:kube-master or G@roles:kube-node':
    - match: compound
    - kube-common.mine-functions

  'roles:kube-master':
    - match: grain
    - kube-master
