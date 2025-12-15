with finance_month as (
  select
    date_trunc(date, month) as datemonth,

    sum(total_transactions) as total_transactions,
    sum(total_revenue) as revenue,
    sum(total_purchase_cost) as purchase_cost,
    sum(operational_margin) as operational_margin,
    sum(total_shipping_fees) as shipping_fee,
    sum(total_log_costs) as log_cost,
    sum(ship_cost) as ship_cost,
    sum(total_quantity_sold) as quantity

  from {{ ref('finance_days') }}
  group by 1
),

campaigns_month as (
  select
    date_trunc(date_date, month) as datemonth,
    sum(coalesce(ads_cost, 0)) as ads_cost,
    sum(coalesce(impression, 0)) as ads_impression,
    sum(coalesce(click, 0)) as ads_clicks
  from {{ ref('int_campaigns_day') }}
  group by 1
)

select
  f.datemonth,
  f.operational_margin - coalesce(c.ads_cost, 0) as ads_margin,
  safe_divide(f.revenue, f.total_transactions) as average_basket,
  f.operational_margin,
  coalesce(c.ads_cost, 0) as ads_cost,
  coalesce(c.ads_impression, 0) as ads_impression,
  coalesce(c.ads_clicks, 0) as ads_clicks,
  f.quantity,
  f.revenue,
  f.purchase_cost,
  f.revenue - f.purchase_cost as margin,
  f.shipping_fee,
  f.log_cost,
  f.ship_cost

from finance_month f
left join campaigns_month c
  using (datemonth)
order by datemonth desc