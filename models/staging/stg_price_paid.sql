with source as (

    select * from {{ source('raw', 'price_paid') }}

),

typed as (

    select
        trim(both '{}' from transaction_id) as transaction_id,
        cast(price as bigint) as price,
        to_date(date_of_transfer, 'yyyy-MM-dd HH:mm') as date_of_transfer,
        nullif(trim(postcode), '') as postcode,

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
            when 'U' then 'Unknown'
        end as tenure,

        ppd_category_type as ppd_category_code,
        case ppd_category_type
            when 'A' then 'Standard'
            when 'B' then 'Additional'
        end as ppd_category,

        nullif(trim(paon), '') as paon,
        nullif(trim(saon), '') as saon,
        nullif(trim(street), '') as street,
        nullif(trim(locality), '') as locality,
        nullif(trim(town_city), '') as town_city,
        nullif(trim(district), '') as district,
        nullif(trim(county), '') as county,

        record_status,
        source_file,
        loaded_at

    from source

)

select * from typed
