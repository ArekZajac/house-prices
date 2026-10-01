{% macro property_key() %}
    concat(property_type_code, old_new_code, duration_code, ppd_category_code)
{% endmacro %}
