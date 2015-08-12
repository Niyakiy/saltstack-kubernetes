# Kubernetes MASTER provisioning
include:
  - kube-common

##
## Kubernetes-master package
##
kube-master-package:
  pkg.installed:
    - name: kubernetes-master
    - skip_verify: True
    - require:
      - pkgrepo: kube-repo

##
## APIServer config and service
##
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
      - file: kube-common-config
    - watch:
      - file: kube-apiserver-config
      - file: kube-common-config

##
## Sceduler config and service
##
kube-scheduler-config:
  file.managed:
    - name: /etc/kubernetes/scheduler
    - template: jinja
    - source: salt://kube-master/files/scheduler.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-master-package

kube-scheduler-service:
  service.running:
    - name: kube-scheduler
    - require:
      - pkg: kube-master-package
      - file: kube-scheduler-config
      - file: kube-common-config
    - watch:
      - file: kube-scheduler-config
      - file: kube-common-config

##
## Controller-Manager config and service
##
kube-controller-config:
  file.managed:
    - name: /etc/kubernetes/controller-manager
    - template: jinja
    - source: salt://kube-master/files/controller-manager.j2
    - require:
      - file: kube-config-dir
      - pkg: kube-master-package

kube-controller-service:
  service.running:
    - name: kube-controller-manager
    - require:
      - pkg: kube-master-package
      - file: kube-controller-config
      - file: kube-common-config
    - watch:
      - file: kube-controller-config
      - file: kube-common-config

