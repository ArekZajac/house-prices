with sale_postcodes as (

    select distinct postcode
    from {{ ref('int_price_paid_current') }}
    where not is_deleted
        and postcode is not null

),

postcodes as (

    select * from {{ ref('stg_postcodes') }}

),

local_authorities as (

    select * from {{ ref('local_authorities') }}

),

regions as (

    select * from {{ ref('regions') }}

)

select
    sale_postcodes.postcode,
    split_part(sale_postcodes.postcode, ' ', 1) as postcode_district,
    postcodes.local_authority_code,
    local_authorities.local_authority_name,
    postcodes.region_code,
    case postcodes.country_code
        when 'W92000004' then 'Wales'
        when 'S92000003' then 'Scotland'
        else regions.region_name
    end as region_name,
    case postcodes.country_code
        when 'E92000001' then 'England'
        when 'W92000004' then 'Wales'
        when 'S92000003' then 'Scotland'
    end as country_name,
    postcodes.latitude,
    postcodes.longitude,
    postcodes.postcode is not null as is_in_nspl
from sale_postcodes
left join postcodes
    on postcodes.postcode = sale_postcodes.postcode
left join local_authorities
    on local_authorities.local_authority_code = postcodes.local_authority_code
left join regions
    on regions.region_code = postcodes.region_code
