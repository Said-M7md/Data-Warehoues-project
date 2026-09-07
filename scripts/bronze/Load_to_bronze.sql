/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as
BEGIN
	DECLARE @start_time Datetime , @end_time Datetime;
	BEGIN TRY
		PRINT '==========================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=========================================='; 

		PRINT '------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT'>>Truncating Table : bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT '>> Inserting Table : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		from 'E:\DWH\datasets\source_crm\cust_info.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Table : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		from 'E:\DWH\datasets\source_crm\prd_info.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table : bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Table : bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		from 'E:\DWH\datasets\source_crm\sales_details.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';

		PRINT '------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table : bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Table : bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		from 'E:\DWH\datasets\source_erp\CUST_AZ12.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Table : bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		from 'E:\DWH\datasets\source_erp\LOC_A101.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';

		set @start_time = GETDATE();
		PRINT '>> Truncating Table : bronze.erp_px_cat_glv2';
		TRUNCATE TABLE bronze.erp_px_cat_glv2;

		PRINT '>> Inserting Table : bronze.erp_px_cat_glv2';
		BULK INSERT bronze.erp_px_cat_glv2
		from 'E:\DWH\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
			Firstrow = 2,
			Fieldterminator = ',',
			tablock
		);
		set @end_time = GETDATE();
		print'>> Loading Duration: ' + cast(Datediff(second,@start_time,@end_time) as nvarchar) + ' seconds';
		PRINT '------------------------------------------';
	END TRY
	BEGIN CATCH
		PRINT'--------------------------------------';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT'Error Message' + Error_Message();
		PRINT'Error Message' + cast( Error_Number() as nvarchar);
		PRINT'Error Message' + cast( Error_State() as nvarchar);
		PRINT'--------------------------------------';
	END CATCH
END
