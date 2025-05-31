
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customerkey
from analytics.dbt_mwoods_northwind.dim_customer
where customerkey is null



  
  
      
    ) dbt_internal_test