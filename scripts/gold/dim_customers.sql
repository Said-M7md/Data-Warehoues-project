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



