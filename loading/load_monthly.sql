-- Appends every monthly update file in the volume that raw does not hold yet,
-- so a rerun loads nothing new.

insert into workspace.raw.price_paid
select
    *,
    _metadata.file_name as source_file,
    current_timestamp() as loaded_at
from read_files(
    '/Volumes/workspace/raw/price_paid_files/monthly/',
    format => 'csv',
    header => false,
    schema => 'transaction_id STRING, price STRING, date_of_transfer STRING, postcode STRING, property_type STRING, old_new STRING, duration STRING, paon STRING, saon STRING, street STRING, locality STRING, town_city STRING, district STRING, county STRING, ppd_category_type STRING, record_status STRING'
)
where _metadata.file_name not in (
    select distinct source_file from workspace.raw.price_paid
);
