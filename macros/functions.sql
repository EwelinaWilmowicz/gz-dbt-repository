{% macro margin_percent(revenue, purchase_cost, decimals=2) %}
  round(
    safe_divide(
      ({{ revenue }} - {{ purchase_cost }}),
      {{ revenue }}
    ),
    {{ decimals }}
  )
{% endmacro %}