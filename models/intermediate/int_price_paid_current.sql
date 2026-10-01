{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='transaction_id',
        on_schema_change='fail'
    )
}}

with records as (

    select * from {{ ref('stg_price_paid') }}

    {% if is_incremental() %}
    where loaded_at > (select coalesce(max(loaded_at), timestamp '1900-01-01') from {{ this }})
    {% endif %}

),

latest as (

    select *
    from records
    qualify row_number() over (
        partition by transaction_id
        order by loaded_at desc, source_file desc
    ) = 1

)

select
    *,
    record_status = 'D' as is_deleted
from latest
