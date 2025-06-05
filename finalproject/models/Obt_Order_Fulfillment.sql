with f_order_fulfillment as (
    select * from {{ ref('Fact_Order_Fulfillment') }}
),
d_customer as (
    select * from {{ ref('Dim_Customer') }}
),
d_product as (
    select * from {{ ref('Dim_Product') }}
),
d_date as (
    select * from {{ ref('Dim_Date') }}
)
    select
        d_customer.*,
        d_product.*,
        d_date.*,
        f.orderlineid,
        f.orderid, 
        f.orderdatekey, 
        f.shippeddatekey, 
        f.quantity, 
        f.leadtime,
        f.orders_by_ship_date,
        f.is_late_shipment,
        f.Source
    from f_order_fulfillment as f
    left join d_customer on f.customerkey = d_customer.CustomerKey
    left join d_product on f.productkey = d_product.productkey
    left join d_date on f.orderdatekey = d_date.datekey