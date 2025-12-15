with adwords as (
    select
        date_date,
        paid_source,
        campaign_key,
        campaign_name,
        cast(ads_cost as float64) as ads_cost,
        cast(impression as int64) as impression,
        cast(click as int64) as click
    from {{ ref('stg_raw__adwords') }}
),

bing as (
    select
        date_date,
        paid_source,
        campaign_key,
        campaign_name,
        cast(ads_cost as float64) as ads_cost,
        cast(impression as int64) as impression,
        cast(click as int64) as click
    from {{ ref('stg_raw__bing') }}
),

criteo as (
    select
        date_date,
        paid_source,
        campaign_key,
        campaign_name,
        cast(ads_cost as float64) as ads_cost,
        cast(impression as int64) as impression,
        cast(click as int64) as click
    from {{ ref('stg_raw__criteo') }}
),

facebook as (
    select
        date_date,
        paid_source,
        campaign_key,
        campaign_name,
        cast(ads_cost as float64) as ads_cost,
        cast(impression as int64) as impression,
        cast(click as int64) as click
    from {{ ref('stg_raw__facebook') }}
),

unioned as (
    select * from adwords
    union all
    select * from bing
    union all
    select * from criteo
    union all
    select * from facebook
)

select *
from unioned