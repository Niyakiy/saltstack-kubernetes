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
## Hosts file (/etc/hosts) records namaged with help of salt.module.mine
##
{% for server, fqdn_data in salt['mine.get']('G@roles:kube-master or G@roles:kube-node', 'grains.item', expr_form='compound').items() %}
cluster-host-{{server}}:
  host.present:
    - names:
      - {{fqdn_data['fqdn']}}
      - {{fqdn_data['host']}}
    - ip: {{fqdn_data['fqdn_ip4'][0]}}
{% endfor %}

