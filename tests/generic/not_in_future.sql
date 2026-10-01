{% test not_in_future(model, column_name) %}

select {{ column_name }}
from {{ model }}
where {{ column_name }} > current_date()

{% endtest %}
