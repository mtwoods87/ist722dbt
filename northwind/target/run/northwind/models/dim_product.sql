
  
    

create or replace transient table analytics.dbt_mwoods_northwind.dim_product
    
    as (with stg_products as (
select * from raw.northwind.Products
)
select md5(cast(coalesce(cast(stg_products.productid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as productkey,
stg_products.*
from stg_products
    )
;


  