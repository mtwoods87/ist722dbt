
  create or replace   view DEMO_DB.dbt_mwoods.my_second_dbt_model
  
   as (
    -- Use the `ref` function to select from other models

select *
from DEMO_DB.dbt_mwoods.my_first_dbt_model
where id = 1
  );

