IF EXISTS (select * from sys.objects where name='case_notes_Indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[case_notes_Indexed]
END
GO

GO

CREATE TABLE [dbo].[case_notes_Indexed](
	[note_key] [int] NOT NULL,
	[note_key_location] [int] NOT NULL,
	[staff_id] [varchar](8) NULL,
	[case_num] [int] NULL,
	[note_time] [datetime] NULL,
	[topic] [varchar](35) NULL,
	[note] [varchar](max) NULL,
	[note_date] [date] NULL,
	[modified_timestamp] [smalldatetime] NULL,
	[case_status] [nvarchar](1) NULL,
	[case_status_attn] [nvarchar](1) NULL,
	[case_status_client] [nvarchar](1) NULL,
	[date_created] [smalldatetime] NULL,
	[staff_created] [varchar](8) NULL,
	[date_modified] [smalldatetime] NULL,
	[staff_modified] [varchar](8) NULL,
	[TableIndex] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [IOC_Clustered_Index_case_notes_Indexed] PRIMARY KEY CLUSTERED 
(
	[TableIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

  
----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_case_notes_Indexed ON [case_notes_Indexed] (case_num);   
----
GO

INSERT INTO [dbo].[case_notes_Indexed]
(      [note_key]
      ,[note_key_location]
      ,[staff_id]
      ,[case_num]
      ,[note_time]
      ,[topic]
      ,[note]
      ,[note_date]
      ,[modified_timestamp]
      ,[case_status]
      ,[case_status_attn]
      ,[case_status_client]
      ,[date_created]
      ,[staff_created]
      ,[date_modified]
      ,[staff_modified]
)
SELECT  [note_key],
      [note_key_location],
      [staff_id],
      [case_num],
      [note_time],
      [topic],
      [note],
      [note_date],
      [modified_timestamp],
      [case_status],
      [case_status_attn],
      [case_status_client],
      [date_created],
      [staff_created],
      [date_modified],
      [staff_modified]
FROM [case_notes]

GO
  
DBCC DBREINDEX('case_notes_Indexed',' ',90) 

GO