# Kubernetes MASTER provisioning
include:
  - kube-common

##
## Kubernetes-master package
##
kube-node-package:
  pkg.installed:
    - name: kubernetes-node
    - skip_verify: True
    - require:
      - pkgrepo: kube-repo

##
## Kubelet config and service
##
kube-kubelet-config:
  file.managed:
    - name: /etc/kubernetes/kubelet
    - template: jinja
    - source: salt://kube-node/files/kubelet.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-node-package

kube-kubelet-service:
  service.running:
    - name: kubelet
    - require:
      - pkg: kube-node-package
      - file: kube-kubelet-config
      - file: kube-common-config
    - watch:
      - file: kube-kubelet-config
      - file: kube-common-config

##
## Kube=Proxy config and service
##
kube-proxy-config:
  file.managed:
    - name: /etc/kubernetes/proxy
    - template: jinja
    - source: salt://kube-node/files/proxy.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-node-package

kube-proxy-service:
  service.running:
    - name: kube-proxy
    - require:
      - pkg: kube-node-package
      - file: kube-proxy-config
      - file: kube-common-config
    - watch:
      - file: kube-proxy-config
      - file: kube-common-config
