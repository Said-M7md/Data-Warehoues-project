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