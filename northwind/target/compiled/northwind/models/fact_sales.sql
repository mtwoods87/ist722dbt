with stg_orders as
(
    select
        OrderID,
        md5(cast(coalesce(cast(employeeid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as employeekey,
        md5(cast(coalesce(cast(customerid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customerkey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from raw.northwind.Orders
),

stg_order_details as
(
    select
        orderid,
        md5(cast(coalesce(cast(productid as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as productkey,
        sum(Quantity) as quantityonorder,
        sum(Quantity*UnitPrice) as extendendpriceamount,
        sum((Quantity*UnitPrice)* Discount) as discountamount
    from raw.northwind.Order_Details
    group by orderid, productid
)

select
    o.*,
    od.productkey,
    od.quantityonorder,
    od.extendendpriceamount,
    od.discountamount,
    od.extendendpriceamount - od.discountamount as soldamount
from stg_orders o
    join stg_order_details od on o.orderid = od.orderid