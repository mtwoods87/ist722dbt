{{ config(
    materialized='table',
    schema='fudgecompanies'
) }}

with
    stg_customers as (select * from {{ source("fudgemart_v3", "fm_customers") }}),
    stg_accounts as (select * from {{ source("fudgeflix_v3", "ff_accounts") }})

select
    {{ dbt_utils.generate_surrogate_key([
        "cast(c.customer_id as varchar)",
        "cast(a.account_id as varchar)"
    ]) }} as CustomerKey,
    coalesce(cast(c.customer_id as varchar), '') || ' ' || coalesce(cast(a.account_id as varchar), '') as CustomerId,
    coalesce(c.customer_email, '') || ' ' || coalesce(a.account_email, '') as CustomerEmail,
    trim(
        coalesce(c.customer_firstname, '') || ' ' || coalesce(c.customer_lastname, '')
    ) || ' ' ||
    trim(
        coalesce(a.account_firstname, '') || ' ' || coalesce(a.account_lastname, '')
    ) as CustomerName,
    coalesce(c.customer_address, '') || ' ' || coalesce(a.account_address, '') as CustomerAddress,
    coalesce(c.customer_zip, '') || ' ' || coalesce(a.account_zipcode, '') as CustomerZipCode,
    case
        when c.customer_id is not null then 'FudgeMart'
        when a.account_id is not null then 'FudgeFlix'
    end as SourceTable
from stg_customers c
full outer join stg_accounts a 
    on cast(c.customer_id as varchar) = cast(a.account_id as varchar)

