select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select customer_id as from_field
    from DEMO_DB.dbt_mwoods.stg_orders
    where customer_id is not null
),

parent as (
    select customer_id as to_field
    from DEMO_DB.dbt_mwoods.stg_customers
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test