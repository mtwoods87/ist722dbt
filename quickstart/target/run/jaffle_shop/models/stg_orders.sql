
  
    

create or replace transient table DEMO_DB.dbt_mwoods.stg_orders
    
    as (select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from raw.jaffle_shop.orders
    )
;


  