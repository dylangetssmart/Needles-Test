-- USE SANeedlesSLF
GO

-- Create Employer Org Contacts from case_intake.Employer_Name_Case
-- saga = ROW_ID

-- Create saga_ref field for another way to find these contacts
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga_ref' AND Object_ID = Object_ID(N'sma_MST_OrgContacts'))
begin
    ALTER TABLE [sma_MST_OrgContacts] ADD [saga_ref] [varchar](100) NULL; 
end
GO

INSERT INTO [sma_MST_OrgContacts]
(
	[consName]
	,[connContactCtg]
	,[connContactTypeID]
	,[connRecUserID]
	,[condDtCreated]
	,[saga]
    ,[saga_ref]
)
SELECT 
	ci.Employer_name_Case		as [consName]
	,2							as [connContactCtg]
	,(
		select octnOrigContactTypeID
		from [sma_MST_OriginalContactTypes]
		where octnContactCtgID=2 and octsDscrptn='General'
	)							as [connContactTypeID]
	,368						as [connRecUserID]
	,getdate()					as [condDtCreated]
	,ci.row_id					as [saga]
    ,'employer'                 as [saga_ref]
from NeedlesSLF..case_intake ci
where isnull(ci.Employer_name_Case,'') <> ''