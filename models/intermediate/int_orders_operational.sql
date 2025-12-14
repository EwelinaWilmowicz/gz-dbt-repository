with orders_margin as (

    select*
    from {{ ref ('int_orders_margin')}}

), 

ship as (

    select *
    from{{ ref ('stg_raw__ship') }}
),

joined as (

        select
        orders_margin.orders_id,
        orders_margin.date_date,
        orders_margin.margin,
        ship.shipping_fee,
        ship.logcost,
        ship.ship_cost
    from orders_margin
    left join ship
        on orders_margin.orders_id = ship.orders_id

),

final as (

    select
        orders_id,
        date_date,
        margin
          + shipping_fee
          - logcost
          - ship_cost as operational_margin
    from joined

)

select *
from final