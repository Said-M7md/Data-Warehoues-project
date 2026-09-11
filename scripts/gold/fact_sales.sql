IF OBJECT_ID('gold.Fact_Sales', 'V') IS NOT NULL
    DROP VIEW gold.Fact_Sales;
GO
CREATE VIEW gold.Fact_Sales AS
select 
	sd.sls_order_dt as Order_Number,
	pr.Product_Key,
	cu.Customer_Key,
	sd.sls_order_dt as Order_Date,
	sd.sls_ship_dt as Shipping_Date,
	sd.sls_due_dt as Due_Date,
	sd.sls_sales as Sales_Amount,
	sd.sls_quantity as Quantity,
	sd.sls_price as Price
from silver.crm_sales_details sd
left join gold.Dim_Products pr
on sd.sls_prd_key = pr.Product_Number
left join gold.Dim_Customers cu
on sls_cust_id = cu.Customer_id