
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select datekey
from analytics.dbt_mwoods_northwind.dim_date
where datekey is null



  
  
      
    ) dbt_internal_test