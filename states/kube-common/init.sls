# Common (master/node) Kubernetes states

# Add reository:
kube-repo:
  {% if salt['grains.get']('os_family', '') == 'RedHat' %}
  pkgrepo.managed:
    - humanname: Kubernetes Repository
    - baseurl: http://cbs.centos.org/repos/virt7-docker-common-candidate/x86_64/os/
    - enabled: True
  {% elif salt['grains.get']('os_family', '') == 'Debian' %}
  {% endif %}

##
## Kube Config dir
##
kube-config-dir:
  file.directory:
    - name: /etc/kubernetes
    - user: root
    - group: root
    - makedirs: True

##
## Kube Common config file
##
kube-common-config:
  file.managed:
    - name: /etc/kubernetes/config
    - template: jinja
    - source: salt://kube-common/files/config.j2
    - require:
      - file: kube-config-dir

##
## Hosts file (/etc/hosts) records namaged with help of salt.module.mine
##
{% for server, fqdn_data in salt['mine.get']('G@roles:kube-master or G@roles:kube-node', 'grains.item', expr_form='compound').items() %}
kube-host-{{server}}:
  host.present:
    - names:
      - {{fqdn_data['fqdn']}}
      - {{fqdn_data['host']}}
    - ip: {{fqdn_data['fqdn_ip4'][0]}}
{% endfor %}

