with sales as (

    select
        dim_date.month_start,
        dim_location.local_authority_code,
        dim_location.local_authority_name,
        dim_location.region_name,
        dim_property.property_type,
        fct_sales.price
    from {{ ref('fct_sales') }} as fct_sales
    inner join {{ ref('dim_date') }} as dim_date
        on dim_date.calendar_date = fct_sales.date_of_transfer
    inner join {{ ref('dim_property') }} as dim_property
        on dim_property.property_key = fct_sales.property_key
    left join {{ ref('dim_location') }} as dim_location
        on dim_location.postcode = fct_sales.postcode
    where dim_property.ppd_category_code = 'A'

)

select
    month_start,
    local_authority_code,
    local_authority_name,
    region_name,
    property_type,
    count(*) as sales,
    median(price) as median_price
from sales
group by all
