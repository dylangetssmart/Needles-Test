IF EXISTS (select * from sys.objects where name='value_Indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[value_Indexed]
END
GO


CREATE TABLE [dbo].[value_Indexed](
    TableIndex [int] IDENTITY(1,1) NOT NULL,
	[value_id] [int] NULL,
	[value_id_location] [int] NULL,
	[party_id] [int] NULL,
	[party_id_location] [int] NULL,
	[case_id] [int] NULL,
	[start_date] [datetime2](0) NULL,
	[stop_date] [datetime2](0) NULL,
	[code] [nvarchar](10) NULL,
	[description] [nvarchar](60) NULL,
	[c_d] [nvarchar](1) NULL,
	[period] [nvarchar](1) NULL,
	[num_periods] [float] NULL,
	[rate] [float] NULL,
	[provider] [int] NULL,
	[provider_id_location] [int] NULL,
	[memo] [nvarchar](150) NULL,
	[total_value] [float] NULL,
	[due] [float] NULL,
	[amount_requested] [float] NULL,
	[report_code] [nvarchar](1) NULL,
	[report_pending] [nvarchar](1) NULL,
	[date_requested] [datetime2](0) NULL,
	[submitted_for_payment] [nvarchar](1) NULL,
	[submitted_date] [datetime2](0) NULL,
	[settlement_memo] [nvarchar](60) NULL,
	[mc_staff_requested] [nvarchar](15) NULL,
	[mc_date_requested] [datetime2](0) NULL,
	[mc_record_request_id] [nvarchar](15) NULL,
	[mc_request_type] [nvarchar](25) NULL,
	[mc_request_id] [nvarchar](15) NULL,
	[reduction] [float] NULL,
	[accounting_id] [nvarchar](200) NULL,
	[case_status] [nvarchar](1) NULL,
	[case_status_attn] [nvarchar](1) NULL,
	[case_status_client] [nvarchar](1) NULL,
	[date_created] [datetime2](0) NULL,
	[staff_created] [nvarchar](8) NULL,
	[date_modified] [datetime2](0) NULL,
	[staff_modified] [nvarchar](8) NULL,
	[app_modified] [nvarchar](20) NULL,
    CONSTRAINT IOC_Clustered_Index_value_Indexed PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY]

GO

----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_Indexed ON [value_Indexed] (value_id);   
----
GO


INSERT INTO [value_Indexed] (      
		[value_id],
		[value_id_location],
		[party_id],
		[party_id_location],
		[case_id],
		[start_date],
		[stop_date],
		[code],
		[description],
		[c_d],
		[period],
		[num_periods],
		[rate],
		[provider],
		[provider_id_location],
		[memo],
		[total_value],
		[due],
		[amount_requested],
		[report_code],
		[report_pending],
		[date_requested],
		[submitted_for_payment],
		[submitted_date],
		[settlement_memo],
		[mc_staff_requested],
		[mc_date_requested],
		[mc_record_request_id],
		[mc_request_type],
		[mc_request_id],
		[reduction],
		[accounting_id],
		[case_status],
		[case_status_attn],
		[case_status_client],
		[date_created],
		[staff_created],
		[date_modified],
		[staff_modified],
		[app_modified]
)
SELECT 
		[value_id],
		[value_id_location],
		[party_id],
		[party_id_location],
		[case_id],
		[start_date],
		[stop_date],
		[code],
		[description],
		[c_d],
		[period],
		[num_periods],
		[rate],
		[provider],
		[provider_id_location],
		[memo],
		[total_value],
		[due],
		[amount_requested],
		[report_code],
		[report_pending],
		[date_requested],
		[submitted_for_payment],
		[submitted_date],
		[settlement_memo],
		[mc_staff_requested],
		[mc_date_requested],
		[mc_record_request_id],
		[mc_request_type],
		[mc_request_id],
		[reduction],
		[accounting_id],
		[case_status],
		[case_status_attn],
		[case_status_client],
		[date_created],
		[staff_created],
		[date_modified],
		[staff_modified],
		[app_modified]
FROM [dbo].[value]
GO


DBCC DBREINDEX('value_Indexed',' ',90) 

GO

