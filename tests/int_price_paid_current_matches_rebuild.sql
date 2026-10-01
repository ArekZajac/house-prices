-- int_price_paid_current is built a month at a time, so check it against
-- rebuilding it from every record in staging. Returns the sales that differ.

with rebuilt as (

    select transaction_id, record_status, source_file, loaded_at
    from {{ ref('stg_price_paid') }}
    qualify row_number() over (
        partition by transaction_id
        order by loaded_at desc, source_file desc
    ) = 1

),

built as (

    select transaction_id, record_status, source_file, loaded_at
    from {{ ref('int_price_paid_current') }}

)

select 'missing or out of date in the model' as problem, *
from (select * from rebuilt except select * from built) as missing

union all

select 'in the model but not in the rebuild' as problem, *
from (select * from built except select * from rebuilt) as extra
