with orders_operational as (

    select *
    from {{ ref ('int_orders_operational')}}

),

orders_margin as (

    select *
    from {{ ref ('int_orders_margin')}}

), 

ship as (

    select *
    from {{ ref ('stg_raw__ship') }}
),

joined as (

    select
        orders_operational.date_date,
        orders_operational.orders_id,

        orders_margin.revenue,
        orders_margin.quantity,
        orders_margin.purchase_cost,
        orders_margin.margin,

        ship.shipping_fee,
        ship.logcost,

        orders_operational.operational_margin

    from orders_operational
    left join orders_margin using (orders_id)
    left join ship using (orders_id)

),

finance_days as (
    select
        date_date as date,
        count(distinct orders_id) as total_transactions,
        sum(revenue) as total_revenue,
        safe_divide(sum(revenue), count(distinct orders_id)) as average_basket, 
        sum(operational_margin) as operational_margin,
        sum(purchase_cost) as total_purchase_cost,
        sum(coalesce(shipping_fee, 0)) as total_shipping_fees,
        sum(coalesce(logcost, 0)) as total_log_costs,
        sum(coalesce(quantity, 0)) as total_quantity_sold

    from joined
    group by date_date
)

select *
from finance_days
order by date
    

