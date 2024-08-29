IF EXISTS (select * from sys.objects where name='party_Indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[party_Indexed]
END
GO


CREATE TABLE [dbo].[party_Indexed](
    TableIndex [int] IDENTITY(1,1) NOT NULL,
	[party_id] [int] NULL,
	[party_id_location] [int] NULL,
	[case_id] [int] NULL,
	[role] [nvarchar](35) NULL,
	[our_client] [nvarchar](1) NULL,
	[relationship] [nvarchar](30) NULL,
	[responsibility] [nvarchar](12) NULL,
	[record_num] [int] NULL,
	[record_num_location] [int] NULL,
	[pclaw_matter] [nvarchar](32) NULL,
	[minor] [nvarchar](1) NULL,
	[date_of_majority] [datetime2](0) NULL,
	[incapacitated] [nvarchar](1) NULL,
	[incapacity] [nvarchar](30) NULL,
	[accounting_id] [nvarchar](200) NULL,
	[case_status] [nvarchar](1) NULL,
	[case_status_attn] [nvarchar](1) NULL,
	[case_status_client] [nvarchar](1) NULL,
    CONSTRAINT IOC_Clustered_Index PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY]
GO
----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_party_id ON [dbo].[party_Indexed] (party_id);   
-----
GO

INSERT INTO [dbo].[party_Indexed] (
		[party_id],
		[party_id_location],
		[case_id],
		[role],
		[our_client],
		[relationship],
		[responsibility],
		[record_num],
		[record_num_location],
		[pclaw_matter],
		[minor],
		[date_of_majority],
		[incapacitated],
		[incapacity],
		[accounting_id],
		[case_status],
		[case_status_attn],
		[case_status_client]
)
SELECT 
		[party_id],
		[party_id_location],
		[case_id],
		[role],
		[our_client],
		[relationship],
		[responsibility],
		[record_num],
		[record_num_location],
		[pclaw_matter],
		[minor],
		[date_of_majority],
		[incapacitated],
		[incapacity],
		[accounting_id],
		[case_status],
		[case_status_attn],
		[case_status_client]
FROM [dbo].[party]
-----
GO
DBCC DBREINDEX('Party_Indexed',' ',90) 
GO

