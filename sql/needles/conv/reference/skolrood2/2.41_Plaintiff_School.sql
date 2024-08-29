-- use SANeedlesSLF

/* ####################################
1.0 -- School/OtherActivities
*/

-- 1.2 Create Grades that don't currently exist
ALTER TABLE [sma_MST_Grades] DISABLE TRIGGER ALL
GO

insert into [sma_MST_Grades]
(
	[grdsCode]
	,[grdsDescription]
	,[grdnRecUserID]
	,[grddDtCreated]
	,[grdnModifyUserID]
	,[grddDtModified]
	,[grdnLevelNo]
)
select distinct
	null				as [grdsCode]
	,ud.Education		as [grdsDescription]
	,368				as [grdnRecUserID]
	,getdate()			as [grddDtCreated]
	,null				as [grdnModifyUserID]
	,null				as [grddDtModified]
	,null				as [grdnLevelNo]
FROM [NeedlesSLF].[dbo].[user_party_data] ud
WHERE isnull(ud.Education,'') <> ''
	AND NOT EXISTS (
		SELECT 1
		FROM [SANeedlesSLF].[dbo].[sma_MST_Grades] g
		WHERE g.grdsDescription = ud.education
);
ALTER TABLE [sma_MST_Grades] ENABLE TRIGGER ALL
GO

GO

-- 1.3 Add school records
	-- See 1.32_Unidentified_School_Contact.sql
ALTER TABLE [sma_TRN_SchoolOthAct] DISABLE TRIGGER ALL
GO

insert into [sma_TRN_SchoolOthAct]
( 
	[schnCaseID]
	,[schnPlaintiffID]
	,[schsType]
	,[schdFromDate]
	,[schdToDate]
	,[schnDays]
	,[schnActivityID]
	,[schnOrgContactID]
	,[schnOrgAddressID]
	,[schnContactPersonID]
	,[schnContactPersonAddID]
	,[schnGradeID]
	,[schbLimitedYN]
	,[schdMDConfReqDt]
	,[schdMDConfRcvdDt]
	,[schdOrgConfReqDt]
	,[schdOrgConfRcvdDt]
	,[schbDocAttached]
	,[schsComments]
	,[schnLossAmount]
	,[schnRecUserID]
	,[schdDtCreated]
	,[schnModifyUserID]
	,[schdDtModified]
	,[schnLevelNo]
	,[schnauthtodefcoun]
	,[schnauthtodefcounDt]
)
select
	cas.casnCaseID				as [schnCaseID]
	,pln.plnnContactID			as [schnPlaintiffID]
	,'S'						as [schsType]
	,null						as [schdFromDate]
	,null						as [schdToDate]
	,null						as [schnDays]
	,0							as [schnActivityID]
	,(
		select connContactID
		from [sma_MST_OrgContacts]
		where consName='Unidentified School' and saga=-1
	)							as [schnOrgContactID]
	,(
		select addnAddressID
		from [sma_MST_Address]
		where addnContactCtgID = 2
		and addnContactID = (
								select connContactID
								from [sma_MST_OrgContacts]
								where consName='Unidentified School'
								and saga=-1
							)
	)							as [schnOrgAddressID]
	,null						as [schnContactPersonID]
	,null						as [schnContactPersonAddID]
	,(
		select grdnGradeID
		from sma_MST_Grades
		where grdsDescription = ud.Education
	)							as [schnGradeID]
	,0							as [schbLimitedYN]
	,null						as [schdMDConfReqDt]
	,null						as [schdMDConfRcvdDt]
	,null						as [schdOrgConfReqDt]
	,null						as [schdOrgConfRcvdDt]
	,0							as [schbDocAttached]
	,null						as [schsComments]
	,null						as [schnLossAmount]
	,368						as [schnRecUserID]
	,getdate()					as [schdDtCreated]
	,null						as [schdDtModified]
	,null						as [schnModifyUserID]
	,1							as [schnLevelNo]
	,0							as [schnauthtodefcoun]
	,null						as [schnauthtodefcounDt]
from NeedlesSLF..user_party_data ud
join sma_TRN_Cases cas
	on cas.cassCaseNumber = ud.case_id
left join sma_TRN_Plaintiff pln
	on pln.plnnCaseID = cas.casnCaseID
where isnull(ud.Education,'') <> ''

ALTER TABLE [sma_TRN_SchoolOthAct] ENABLE TRIGGER ALL
GO