with combinations as (

    select distinct
        property_type_code,
        property_type,
        old_new_code,
        is_new_build,
        duration_code,
        tenure,
        ppd_category_code,
        ppd_category
    from {{ ref('int_price_paid_current') }}
    where not is_deleted

)

select
    {{ property_key() }} as property_key,
    property_type_code,
    property_type,
    case
        when property_type_code = 'F' then 'Flat'
        when property_type_code in ('D', 'S', 'T') then 'House'
        else 'Other'
    end as dwelling_type,
    old_new_code,
    is_new_build,
    duration_code,
    tenure,
    ppd_category_code,
    ppd_category
from combinations
