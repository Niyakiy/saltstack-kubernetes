# ETCD installation 
etcd-package:
  pkg.installed:
    - name: etcd
    
etcd-config:
  file.managed:
    - name: /etc/etcd/etcd.conf
    - template: jinja
    - source: salt://etcd/files/etcd.conf.j2

etcd-service:
  service.running:
    - name: etcd
    - requires:
      - pkg: etcd-package
      - file: etcd-config
    - watch:
      - file: etcd-config
