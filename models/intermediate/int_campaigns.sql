with unioned as (

  {{ dbt_utils.union_relations(
      relations=[
        ref('stg_raw__adwords'),
        ref('stg_raw__bing'),
        ref('stg_raw__criteo'),
        ref('stg_raw__facebook')
      ]
  ) }}

)

select
  date_date,
  paid_source,
  cast(campaign_key as string) as campaign_id,
  campaign_name,
  lower(regexp_extract(_dbt_source_relation, r"stg_raw__([a-zA-Z0-9_]+)")) as source,
  cast(ads_cost as float64) as ads_cost,
  cast(impression as int64) as impression,
  cast(click as int64) as click
from unioned