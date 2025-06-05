{{ config(
    materialized='table',
    schema='fudgecompanies'
) }}

with
    stg_orders as 
    (
        select 
            o.order_id as orderid,
            d.customerkey,  
            replace(to_date(o.order_date)::varchar,'-','')::int as orderdatekey,
            replace(to_date(o.shipped_date)::varchar,'-','')::int as shippeddatekey
        from {{ source("fudgemart_v3", "fm_orders") }} o
        left join {{ ref('Dim_Customer') }} d on o.customer_id  = d.CustomerId
    ),

    stg_order_details as 
(
    select 
        o.order_id as orderid,
        dp.productkey as productkey,
        o.order_qty as quantity
    from {{ source("fudgemart_v3", "fm_order_details") }} o
    left join {{ ref('Dim_Product') }} dp on trim(cast(o.product_id as varchar)) = trim(dp.ProductId)
),


    stg_account_titles as 
    (
        select 
            at_id as orderid,
            dc.CustomerId as customerkey,
            dp.ProductId as productkey,
            replace(to_date(at_queue_date)::varchar,'-','')::int as orderdatekey,
            replace(to_date(at_shipped_date)::varchar,'-','')::int as shippeddatekey
        from {{ source("fudgeflix_v3", "ff_account_titles") }} a
        left join {{ ref('Dim_Customer') }} dc on cast(a.at_account_id as varchar) = dc.CustomerId
        left join {{ ref('Dim_Product') }} dp on a.at_title_id = dp.ProductId
    )

select
    {{ dbt_utils.generate_surrogate_key(['coalesce(o.orderid, a.orderid)', 'coalesce(od.productkey, a.productkey)']) }} as orderlineid,
    coalesce(o.orderid, a.orderid) as orderid,
    coalesce(od.productkey, a.productkey) as productkey,
    coalesce(o.customerkey, a.customerkey) as customerkey,
    coalesce(o.orderdatekey, a.orderdatekey) as orderdatekey,
    coalesce(o.shippeddatekey, a.shippeddatekey) as shippeddatekey,
    od.quantity,
    coalesce(o.shippeddatekey - o.orderdatekey, a.shippeddatekey - o.orderdatekey) as leadtime,
    count(distinct coalesce(o.orderid, a.orderid)) over (
        partition by coalesce(o.shippeddatekey, a.shippeddatekey)
    ) as orders_by_ship_date,
    case
    when coalesce(o.shippeddatekey, a.shippeddatekey) - coalesce(o.orderdatekey, a.orderdatekey) > 5 
    then 1 
    else 0 
    end as is_late_shipment,
    case
        when o.orderid is not null then 'FudgeMart'
        when a.orderid is not null then 'FudgeFlix'
    end as Source
from stg_orders o
    join stg_order_details od on o.orderid = od.orderid
    full outer join stg_account_titles a on o.orderid = a.orderid