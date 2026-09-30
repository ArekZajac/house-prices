with source as (

    select * from {{ source('raw', 'nspl') }}

),

renamed as (

    select
        pcds as postcode,
        split_part(pcds, ' ', 1) as postcode_district,
        to_date(dointr, 'yyyyMM') as introduced_on,
        to_date(nullif(doterm, ''), 'yyyyMM') as terminated_on,
        nullif(doterm, '') is null as is_live,

        {{ nspl_code('lad26cd') }} as local_authority_code,
        {{ nspl_code('cty26cd') }} as county_code,
        {{ nspl_code('rgn26cd') }} as region_code,
        {{ nspl_code('ctry26cd') }} as country_code,

        case when gridind != '9' then cast(lat as double) end as latitude,
        case when gridind != '9' then cast(`long` as double) end as longitude,

        source_file,
        loaded_at

    from source

)

select * from renamed
