with stg_orders as
(
    select
        OrderID,
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey,
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey,
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{source('northwind','Orders')}}
),

stg_order_details as
(
    select
        orderid,
        {{ dbt_utils.generate_surrogate_key(['productid']) }} as productkey,
        sum(Quantity) as quantityonorder,
        sum(Quantity*UnitPrice) as extendendpriceamount,
        sum((Quantity*UnitPrice)* Discount) as discountamount
    from {{source('northwind','Order_Details')}}
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