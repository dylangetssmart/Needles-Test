IF EXISTS (select * from sys.objects where name='insurance_Indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[insurance_Indexed]
END
GO

CREATE TABLE [dbo].[insurance_Indexed](
		TableIndex [int] IDENTITY(1,1) NOT NULL,
		[insurance_id] [int] NULL,
		[insurance_id_location] [int] NULL,
		[party_id] [int] NULL,
		[party_id_location] [int] NULL,
		[case_num] [int] NULL,
		[insurer_id] [int] NULL,
		[insurer_id_location] [int] NULL,
		[adjuster_id] [int] NULL,
		[adjuster_id_location] [int] NULL,
		[policy] [nvarchar](25) NULL,
		[claim] [nvarchar](30) NULL,
		[insured] [nvarchar](50) NULL,
		[limits] [nvarchar](50) NULL,
		[accept] [nvarchar](1) NULL,
		[agent] [nvarchar](30) NULL,
		[policy_type] [nvarchar](35) NULL,
		[comments] [nvarchar](max) NULL,
		[minimum_amount] [float] NULL,
		[maximum_amount] [float] NULL,
		[actual] [float] NULL,
		[date_settled] [datetime2](0) NULL,
		[how_settled] [nvarchar](35) NULL,
		[case_status] [nvarchar](1) NULL,
		[case_status_attn] [nvarchar](1) NULL,
		[case_status_client] [nvarchar](1) NULL,
		CONSTRAINT IOC_Clustered_Index_insurance PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_insurance_Indexed ON [dbo].[insurance_Indexed] (insurance_id);   

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_insurance_Indexed_case_num ON [dbo].[insurance_Indexed] (case_num);   
GO


INSERT INTO [dbo].[insurance_Indexed] (       
		[insurance_id],
		[insurance_id_location],
		[party_id],
		[party_id_location],
		[case_num],
		[insurer_id],
		[insurer_id_location],
		[adjuster_id],
		[adjuster_id_location],
		[policy],
		[claim],
		[insured],
		[limits],
		[accept],
		[agent],
		[policy_type],
		[comments],
		[minimum_amount],
		[maximum_amount],
		[actual],
		[date_settled],
		[how_settled],
		[case_status],
		[case_status_attn],
		[case_status_client]
)
SELECT 
		[insurance_id],
		[insurance_id_location],
		[party_id],
		[party_id_location],
		[case_num],
		[insurer_id],
		[insurer_id_location],
		[adjuster_id],
		[adjuster_id_location],
		[policy],
		[claim],
		[insured],
		[limits],
		[accept],
		[agent],
		[policy_type],
		[comments],
		[minimum_amount],
		[maximum_amount],
		[actual],
		[date_settled],
		[how_settled],
		[case_status],
		[case_status_attn],
		[case_status_client]
FROM [dbo].[insurance]
GO

DBCC DBREINDEX('insurance_Indexed',' ',90) 
