-- USE SANeedlesSLF
GO

--- saga=-1: consName="Unidentified Court"
---


IF NOT EXISTS (select * from [sma_MST_OrgContacts] where consName='Unidentified Court' and saga=-1)
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
	'Unidentified Court'		as [consName]
	,2							as [connContactCtg]
	,(
		select octnOrigContactTypeID
		from [sma_MST_OriginalContactTypes]
		where octnContactCtgID=2 and octsDscrptn='Court'
	)							as [connContactTypeID]
	,368						as [connRecUserID]
	,getdate()					as [condDtCreated]
	,-1							as [saga]
END


--------------------------------------------
--INSERT HEARING LOCATIONS AS COURTS
--------------------------------------------
--INSERT INTO [sma_MST_OrgContacts] (
--		[consName],
--		[connContactCtg],
--		[connContactTypeID],
--		[connRecUserID],
--		[condDtCreated],
--		[saga]
--	)
--SELECT DISTINCT
--		hearing_Location			as [consName],
--		2							as [connContactCtg],
--		(select octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] where octnContactCtgID=2 and octsDscrptn='Court') as [connContactTypeID],
--		368							as [connRecUserID],	
--		getdate()					as [condDtCreated],
--		-1							as [saga]
----select Distinct hearing_Location
--from NeedlesSLF..user_tab4_data
--where isnull(hearing_Location,'')<>''