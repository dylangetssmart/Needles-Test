IF EXISTS (select * from sys.objects where name='CaseTypeMixture')
BEGIN
    DROP TABLE [dbo].[CaseTypeMixture]
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CaseTypeMixture]
(
	[matcode] [nvarchar](255) NULL
	,[header] [nvarchar](255) NULL
	,[description] [nvarchar](255) NULL
	,[SmartAdvocate Case Type] [nvarchar](255) NULL
	,[SmartAdvocate Case Sub Type] [nvarchar](255) NULL
) ON [PRIMARY]


INSERT INTO [dbo].[CaseTypeMixture]
(
	[matcode]
	,[header]
	,[description]
	,[SmartAdvocate Case Type]
	,[SmartAdvocate Case Sub Type]
)

-- matcode, header, description, SA case type, SA case sub type
SELECT 'BR', 'BANKRUPT', 'Bankruptcy', 'Bankruptcy', '' UNION
SELECT 'DS', 'DSBLITY', 'Disability - Social Security', 'Disability - Social Security', '' UNION
SELECT 'MC', 'MTRCYCLE', ' Motorcycle Accident', ' Motorcycle Accident', '' UNION
SELECT 'MM', 'MED MAL', 'Medical Malpractice', 'Medical Malpractice', '' UNION
SELECT 'PL', 'PREMISES', 'Premises Liability', 'Premises Liability', '' UNION
SELECT 'PR', 'PROD LIA', 'Product Liability', 'Product Liability', '' UNION
SELECT 'TOX', 'CAMP LEJ', 'Camp Lejeune', 'Camp Lejeune', '' UNION
SELECT 'WC', 'WORKCOMP', 'Worker''s Compensation', 'Worker''s Compensation', '' UNION
SELECT 'ZIN', 'INTAKE', 'Intake - Prospective Client', 'Intake - Prospective Client', '' UNION
SELECT 'ZLN', 'LIEN', 'P W/D S&S HAS LIEN ON CASE', 'P W/D S&S HAS LIEN ON CASE', ''
