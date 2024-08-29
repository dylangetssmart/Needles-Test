IF EXISTS (select * from sys.objects where name='checklist_dir_indexed' and type='U')
BEGIN
	DROP TABLE [dbo].[checklist_dir_indexed]
END
GO


/****** Object:  Table [dbo].[checklist_dir]    Script Date: 2/17/2021 10:42:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[checklist_dir_indexed](
	[UID] [int] IDENTITY(1,1) NOT NULL,
	[matcode] [varchar](10) NOT NULL,
	[code] [varchar](3) NOT NULL,
	[description] [varchar](200) NULL,
	[phase] [varchar](1) NULL,
	[new_item] [varchar](1) NULL,
	[staff_num] [int] NULL,
	[litigation] [varchar](1) NULL,
	[ref] [varchar](3) NULL,
	[repeat_period] [varchar](1) NULL,
	[repeat_days] [int] NULL,
	[document] [int] NULL,
	[parent] [varchar](1) NULL,
	[pdf_form] [int] NULL,
	[lim] [varchar](1) NULL,
	[case_status] [varchar](1) NULL,
	[case_status_attn] [varchar](1) NULL,
	[case_status_client] [varchar](1) NULL,
	[text_color] [int] NULL,
	[background_color] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[matcode] ASC,
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_checklist_dir_indexed ON [checklist_dir_indexed] ([UID]);   

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_checklist_dir_indexed_Matcode ON [checklist_dir_indexed] (matcode);   
GO

INSERT INTO [dbo].[checklist_dir_indexed] (
           [matcode],
           [code],
           [description],
           [phase],
           [new_item],
           [staff_num],
           [litigation],
           [ref],
           [repeat_period],
           [repeat_days],
           [document],
           [parent],
           [pdf_form],
           [lim],
           [case_status],
           [case_status_attn],
           [case_status_client],
           [text_color],
           [background_color])
SELECT 
		[matcode],
        [code],
        [description],
        [phase],
        [new_item],
        [staff_num],
        [litigation],
        [ref],
        [repeat_period],
        [repeat_days],
        [document],
        [parent],
        [pdf_form],
        [lim],
        [case_status],
        [case_status_attn],
        [case_status_client],
        [text_color],
        [background_color]
FROM [checklist_dir]
GO

DBCC DBREINDEX('checklist_dir_indexed',' ',90)