# Kubernetes MASTER provisioning
include:
  - kube-common

kube-master-package:
  pkg.installed:
    - name: kubernetes-master
    - skip_verify: True
    - require:
      - pkgrepo: kube-repo

kube-apiserver-config:
  file.managed:
    - name: /etc/kubernetes/apiserver
    - template: jinja
    - source: salt://kube-master/files/apiserver.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-master-package

kube-apiserver-service:
  service.running:
    - name: kube-apiserver
    - require:
      - pkg: kube-master-package
      - file: kube-apiserver-config
    - watch:
      - file: kube-apiserver-config

kube-scheduler-config:
  file.managed:
    - name: /etc/kubernetes/scheduler
    - template: jinja
    - source: salt://kube-master/files/scheduler.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-master-package