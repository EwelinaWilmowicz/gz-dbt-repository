with sales as (

    select *
    from {{ ref ('stg_raw__sales') }}

),

product as (

    select *
    from{{ ref ('stg_raw__product') }}
)

select
    sales.date_date,
    sales.orders_id,
    sales.products_id,
    sales.quantity,
    sales.revenue,
    product.purchase_price,
    cast(sales.quantity as int64) * cast(product.purchase_price as float64) as purchase_cost,
    cast(sales.revenue as float64)
      - (cast(sales.quantity as int64) * cast(product.purchase_price as float64)) as margin
from sales
left join product
   on sales.products_id = product.products_id
   