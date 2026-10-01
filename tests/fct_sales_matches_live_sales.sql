-- Every live sale in int_price_paid_current reaches fct_sales once, so a join
-- added to the fact later cannot drop or duplicate sales unnoticed.

with expected as (

    select count(*) as sales
    from {{ ref('int_price_paid_current') }}
    where not is_deleted

),

actual as (

    select count(*) as sales
    from {{ ref('fct_sales') }}

)

select
    expected.sales as expected_sales,
    actual.sales as actual_sales
from expected
cross join actual
where expected.sales != actual.sales
