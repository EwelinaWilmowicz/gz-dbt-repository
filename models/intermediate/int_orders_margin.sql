with sales_margin as (

    select*
    from {{ ref ('int_sales_margin')}}

), 

orders_margin as (

    select
    orders_id,
    min(date_date) as date_date,
    sum(revenue) as revenue,
    sum(quantity) as quantity,
    sum(purchase_cost) as purchase_cost,
    sum(margin) as margin

    from sales_margin
    GROUP BY orders_id

)

select *
from orders_margin