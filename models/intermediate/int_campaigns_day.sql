select
  date_date,
  sum(coalesce(ads_cost, 0)) as ads_cost,
  sum(coalesce(impression, 0)) as impression,
  sum(coalesce(click, 0)) as click
from {{ ref('int_campaigns') }}
group by 1
order by date_date desc