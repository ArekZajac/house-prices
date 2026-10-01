with days as (

    select explode(sequence(date '1995-01-01', make_date(year(current_date()), 12, 31), interval 1 day)) as calendar_date

),

financial_years as (

    select
        *,
        case when month(calendar_date) >= 4 then year(calendar_date) else year(calendar_date) - 1 end as financial_year_start
    from days

)

select
    calendar_date,
    year(calendar_date) as year,
    quarter(calendar_date) as quarter,
    format_string('%d Q%d', year(calendar_date), quarter(calendar_date)) as year_quarter,
    month(calendar_date) as month,
    date_format(calendar_date, 'MMMM') as month_name,
    trunc(calendar_date, 'MM') as month_start,
    format_string('%d-%02d', financial_year_start, (financial_year_start + 1) % 100) as financial_year
from financial_years
