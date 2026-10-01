with sales as (

    select * from {{ ref('int_price_paid_current') }}
    where not is_deleted

)

select
    transaction_id,
    date_of_transfer,
    postcode,
    {{ property_key() }} as property_key,
    price
from sales
