Account "{{ account.name }}"
Customer "{{ account.customerName }}"

Orders
======
{% for order in account.orders -%}
Order ID #{{ order.orderId }}
Product #{{ order.productId }}, {{ order.productName }}
  Price {{ order.price }}

{% endfor -%}

Total {% by_path "sum(account.orders[*].price)" %}
