/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

IF OBJECT_ID('gold.Dim_Customers', 'V') IS NOT NULL
    DROP VIEW gold.Dim_Customers;
GO
CREATE VIEW gold.Dim_Customers AS
	SELECT 
		ROW_NUMBER() OVER (ORDER BY cst_id ) AS Customer_Key,
		ci.cst_id as Customer_id,
		ci.cst_key as Customer_Number,
		ci.cst_firstname as First_Name,
		ci.cst_lastname as Last_Name,
		la.CNTRY as Country,
		ci.cst_marital_status as Marital_Status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE (ca.GEN,'n/a')
		END AS Gender,
		ca.BDATE as Birthdate,
		ci.cst_create_date as Create_Date
	FROM silver.crm_cust_info ci
	left join silver.erp_cust_az12 ca
	on ci.cst_key = ca.CID
	left join silver.erp_loc_a101 la
	on ci.cst_key = la.CID
GO
  
-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
  
IF OBJECT_ID('gold.Dim_Products', 'V') IS NOT NULL
    DROP VIEW gold.Dim_Products;
GO
CREATE VIEW gold.Dim_Products AS
select 
	ROW_NUMBER() OVER (ORDER BY pd.prd_start_dt , pd.prd_key) AS Product_Key,
	pd.prd_id as Product_id,
	pd.prd_key as Product_Number,
	pd.prd_nm as Product_Name,
	pd.cat_id as Category_id,
	pc.CAT as Category,
	pc.SUBCAT as Subcategory,
	pc.MAINTENANCE as Maintenance,
	pd.prd_cost as Cost ,
	pd.prd_line as Product_Line,
	pd.prd_start_dt as Start_Date
from silver.crm_prd_info pd
left join silver.erp_px_cat_glv2 pc
on pd.cat_id = pc.ID
where prd_end_dt is null
GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

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
GO

