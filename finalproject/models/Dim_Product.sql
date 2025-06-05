{{ config(
    materialized='table',
    schema='fudgecompanies'  
) }}

with
    stg_products as (select * from {{ source("fudgemart_v3", "fm_products") }}),

    stg_titles as (select * from {{ source("fudgeflix_v3", "ff_titles") }})

select
    {{dbt_utils.generate_surrogate_key(["cast(p.product_id as varchar)", "t.title_id"])}} as ProductKey,
    coalesce(cast(p.product_id as varchar), '') || ' ' || coalesce(t.title_id, '') as ProductId,
    coalesce(p.product_name, '') || ' ' || coalesce(t.title_name, '') as ProductName,
    coalesce(p.product_description, '') || ' ' || coalesce(t.title_synopsis, '') as ProductDescription,
    coalesce(p.product_department, '') || ' ' || coalesce(t.title_type, '') as ProductType,
    case
        when p.product_id is not null
        then 'FudgeMart'
        when t.title_id is not null
        then 'FudgeFlix'
    end as Source
from stg_products p
full outer join stg_titles t on cast(p.product_id as varchar) = t.title_id
