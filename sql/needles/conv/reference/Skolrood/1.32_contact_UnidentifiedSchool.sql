-- USE SANeedlesSLF
GO

IF NOT EXISTS (select * from [sma_MST_OrgContacts] where consName='Unidentified School' and saga=-1)
BEGIN

INSERT INTO [sma_MST_OrgContacts]
(
	[consName]
	,[connContactCtg]
	,[connContactTypeID]
	,[connRecUserID]
	,[condDtCreated]
	,[saga]
)
SELECT 
	'Unidentified School'		as [consName]
	,2							as [connContactCtg]
	,(
		select octnOrigContactTypeID
		from [sma_MST_OriginalContactTypes]
		where octnContactCtgID=2 and octsDscrptn='General'
	)							as [connContactTypeID]
	,368						as [connRecUserID]
	,getdate()					as [condDtCreated]
	,-1							as [saga]
END