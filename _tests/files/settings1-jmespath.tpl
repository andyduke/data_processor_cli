Server: {{ settings.network.hostname }}

Priveleged shares: {% by_path "settings.shares[?priveleges]" %}
