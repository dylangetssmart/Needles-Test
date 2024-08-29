IF EXISTS (select * from sys.objects where name='counsel_Indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[counsel_Indexed]
END
GO

CREATE TABLE [dbo].[counsel_Indexed](
    TableIndex [int] IDENTITY(1,1) NOT NULL,
	[party_id] [int] NULL,
	[party_id_location] [int] NULL,
	[case_num] [int] NULL,
	[counsel_id] [int] NULL,
	[counsel_id_location] [int] NULL,
	[comments] [nvarchar](max) NULL,
	[case_status] [nvarchar](1) NULL,
	[case_status_attn] [nvarchar](1) NULL,
	[case_status_client] [nvarchar](1) NULL,
	[cert_of_srv_order] [int] NULL,
    CONSTRAINT IOC_Clustered_Index_counsel PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_counsel_Indexed ON [dbo].[counsel_Indexed] (party_id);   
GO  

INSERT INTO [dbo].[counsel_Indexed]
(
		[party_id],
		[party_id_location],
		[case_num],
		[counsel_id],
		[counsel_id_location],
		[comments],
		[case_status],
		[case_status_attn],
		[case_status_client],
		[cert_of_srv_order]
)
SELECT 
		[party_id],
		[party_id_location],
		[case_num],
		[counsel_id],
		[counsel_id_location],
		[comments],
		[case_status],
		[case_status_attn],
		[case_status_client],
		[cert_of_srv_order]
FROM [dbo].[counsel]
GO

-----
DBCC DBREINDEX('counsel_Indexed',' ',90) 

GO


