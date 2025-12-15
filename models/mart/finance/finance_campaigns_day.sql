with finance as (
  select
    date,
    average_basket,
    operational_margin,

    total_quantity_sold   as quantity,
    total_revenue         as revenue,
    total_purchase_cost   as purchase_cost,
    ship_cost,
    total_shipping_fees   as shipping_fee,
    total_log_costs       as log_cost

  from {{ ref('finance_days') }}
),

campaigns as (
  select
    date_date,
    ads_cost,
    impression,
    click
  from {{ ref('int_campaigns_day') }}
)

select
  f.date as date,
  f.operational_margin - coalesce(c.ads_cost, 0) as ads_margin,

  f.average_basket,
  f.operational_margin,

  coalesce(c.ads_cost, 0)      as ads_cost,
  coalesce(c.impression, 0)    as ads_impression,
  coalesce(c.click, 0)         as ads_clicks,

  f.quantity,
  f.revenue,
  f.purchase_cost,
  f.revenue - f.purchase_cost  as margin,
  f.shipping_fee,
  f.log_cost,
  f.ship_cost

from finance f
left join campaigns c
  on f.date = c.date_date
order by date desc