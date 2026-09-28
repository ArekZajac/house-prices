with source as (

    select * from {{ source('raw', 'price_paid') }}

),

typed as (

    select
        trim(both '{}' from transaction_id) as transaction_id,
        cast(price as bigint) as price,
        to_date(date_of_transfer, 'yyyy-MM-dd HH:mm') as date_of_transfer,
        nullif(postcode, '') as postcode,

        property_type as property_type_code,
        case property_type
            when 'D' then 'Detached'
            when 'S' then 'Semi-detached'
            when 'T' then 'Terraced'
            when 'F' then 'Flat or maisonette'
            when 'O' then 'Other'
        end as property_type,

        old_new as old_new_code,
        old_new = 'Y' as is_new_build,

        duration as duration_code,
        case duration
            when 'F' then 'Freehold'
            when 'L' then 'Leasehold'
        end as tenure,

        ppd_category_type as ppd_category_code,
        case ppd_category_type
            when 'A' then 'Standard'
            when 'B' then 'Additional'
        end as ppd_category,

        nullif(paon, '') as paon,
        nullif(saon, '') as saon,
        nullif(street, '') as street,
        nullif(locality, '') as locality,
        nullif(town_city, '') as town_city,
        nullif(district, '') as district,
        nullif(county, '') as county,

        record_status,
        source_file,
        loaded_at

    from source

)

select * from typed
