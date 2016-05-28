{% from "apt/map.jinja" import apt as apt_map with context %}
{% set remove_apt_conf = salt['pillar.get']('apt:remove_apt_conf', apt_map.remove_apt_conf) %}
{% set confd_dir = salt['pillar.get']('apt:confd_dir', apt_map.confd_dir) %}
{% set clean_conf_d = salt['pillar.get']('apt:clean_conf_d', apt_map.clean_conf_d) %}
{% set apt_conf = salt['pillar.get']('apt:conf', apt_map.conf) %}
{% if remove_apt_conf %}
/etc/apt/apt.conf:
  file:
    - absent
{% endif %}

{{ confd_dir }}:
  file.directory:
    - mode: 755
    - user: root
    - group: root
    - clean: {{ clean_conf_d }}

{% for file, contents in apt_conf|dictsort %}
{{ confd_dir }}/{{ file }}:
  file.managed:
    - source: salt://apt/templates/conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        data: {{ contents }}
{% endfor %}
