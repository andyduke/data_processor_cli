[general]
server name = {{ settings.network.hostname }}

{% for share in settings.shares -%}
[{{ share.name }}]
path = {{ share.path }}
{% if share.priveleges -%}
user = {{ share.priveleges.user }}
mode = {{ share.priveleges.perms }}
{% endif %}
{% endfor -%}

[printers]
enabled = no
