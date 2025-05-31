
  
    

create or replace transient table analytics.dbt_mwoods_northwind.obt_sales
    
    as (with f_sales as (
    select * from analytics.dbt_mwoods_northwind.fact_sales
),
d_customer as (
    select * from analytics.dbt_mwoods_northwind.dim_customer
),
d_employee as (
    select * from analytics.dbt_mwoods_northwind.dim_employee
),
d_date as (
    select * from analytics.dbt_mwoods_northwind.dim_date
),
d_product as (
    select * from analytics.dbt_mwoods_northwind.dim_product
)
    select
        d_customer.*,
        d_employee.*,
        d_date.*,
        d_product.*,
        s.orderdatekey,
        s.quantityonorder,
        s.extendendpriceamount,
        s.discountamount,
        s.soldamount
    from f_sales as s
    left join d_customer on s.customerkey = d_customer.customerkey
    left join d_employee on s.employeekey = d_employee.employeekey
    left join d_date on s.orderdatekey = d_date.datekey
    left join d_product on s.productkey = d_product.productkey
    )
;


  