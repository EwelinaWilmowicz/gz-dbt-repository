with sales as (

    select *
    from {{ ref ('stg_raw__sales') }}

),

product as (

    select *
    from{{ ref ('stg_raw__product') }}
),

calc as (
  select
    s.date_date,
    s.orders_id,
    s.products_id,
    s.quantity,
    cast(s.revenue as float64) as revenue,
    p.purchase_price,
    cast(s.quantity as int64) * cast(p.purchase_price as float64) as purchase_cost
  from sales s
  left join product p
    on s.products_id = p.products_id
)

select
  date_date,
  orders_id,
  products_id,
  quantity,
  revenue,
  purchase_price,
  purchase_cost,
  revenue - purchase_cost as margin,
  {{ margin_percent('revenue', 'purchase_cost') }} as margin_percent
from calc