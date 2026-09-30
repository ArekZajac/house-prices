{% macro nspl_code(column) %}
    case
        when {{ column }} = '' or {{ column }} like '_99999999' then null
        else {{ column }}
    end
{% endmacro %}
