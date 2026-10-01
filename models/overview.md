{% docs __overview__ %}
# UK house prices

Every residential sale in England and Wales since 1995, from HM Land Registry's Price Paid Data, modelled with dbt on Databricks into a star schema for Power BI.

- **Staging** types and decodes the raw files: `stg_price_paid` and `stg_postcodes`.
- **Intermediate** applies Land Registry's monthly additions, changes and deletions to the history: `int_price_paid_current`.
- **Marts** are the star schema, `fct_sales` with `dim_date`, `dim_location` and `dim_property`, plus the aggregate `mart_monthly_prices`.

Code: [github.com/ArekZajac/house-prices](https://github.com/ArekZajac/house-prices)

## Data and licences

Contains HM Land Registry data © Crown copyright and database right 2026. This data is licensed under the Open Government Licence v3.0.

Postcode geography from the ONS National Statistics Postcode Lookup. Contains OS data © Crown copyright and database right 2026. Contains Royal Mail data © Royal Mail copyright and database right 2026. Source: Office for National Statistics licensed under the Open Government Licence v.3.0.
{% enddocs %}
