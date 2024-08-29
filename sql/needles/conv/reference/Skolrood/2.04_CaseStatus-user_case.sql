-- use SANeedlesSLF
-- GO

/*
alter table [sma_TRN_CaseStatus] disable trigger all
delete from [sma_TRN_CaseStatus]
DBCC CHECKIDENT ('[sma_TRN_CaseStatus]', RESEED, 0);
alter table [sma_TRN_CaseStatus] enable trigger all
*/

/* ########################################################
1. Create "Grade" status type in sma_mst_CaseStatusType
2. Add distinct Grade values into sma_mst_CaseStatus
3. Update appropriate cases with the Grade status type and description
*/


/* ########################################################
1. Create "Grade" status type in sma_mst_CaseStatusType
*/
alter table [sma_MST_CaseStatusType] disable trigger all

insert into [sma_MST_CaseStatusType]
(	
	[stpsCode]
	,[stpsStatusType]
	,[stpnRecUserID]
	,[stpdDtCreated]
	,[stpnModifyUserID]
	,[stpdDtModified]
	,[stpnLevelNo]
)
select
	null 					as [stpsCode]
	,'Grade'				as [stpsStatusType]
	,368					as [stpnRecUserID]
	,GETDATE()				as [stpdDtCreated]
	,null					as [stpnModifyUserID]
	,null					as [stpdDtModified]
	,null					as [stpnLevelNo]

/* ########################################################
2. Add distinct Grade values into sma_mst_CaseStatus
*/
insert into [sma_MST_CaseStatus]
(
	[csssCode]
	,[csssDescription]
	,[cssnStatusTypeID]
	,[cssnClientStatusID]
	,[cssnExpNoOfDays]
	,[cssnRecUserID]
	,[cssdDtCreated]
	,[cssnModifyUserID]
	,[cssdDtModified]
	,[cssnLevelNo]
	,[cssbBlockRetComment]
	,[SGsStatusType]
	,[cssbShowInOverDueDashboard]
	,[LimitStatusGroups]
)
select distinct
	null 				as [csssCode]
	,d.Grade 			as [csssDescription]
	,(
		select stpnStatusTypeID
		from sma_MST_CaseStatusType
		where stpsStatusType = 'Grade'
	)					as [cssnStatusTypeID]
	,null 				as [cssnClientStatusID]
	,null 				as [cssnExpNoOfDays]
	,368 				as [cssnRecUserID]
	,GETDATE() 			as [cssdDtCreated]
	,null 				as [cssnModifyUserID]
	,null 				as [cssdDtModified]
	,null 				as [cssnLevelNo]
	,null 				as [cssbBlockRetComment]
	,null 				as [SGsStatusType]
	,null 				as [cssbShowInOverDueDashboard]
	,null 				as [LimitStatusGroups]
from NeedlesSLF..user_case_data d
where isnull(d.Grade,'') <> ''

alter table [sma_MST_CaseStatusType] enable trigger all

/* ########################################################
3. Update appropriate cases with the Grade status type and description
*/
alter table [sma_TRN_CaseStatus] disable trigger all

INSERT INTO [sma_TRN_CaseStatus] (
	[cssnCaseID],
	[cssnStatusTypeID],
	[cssnStatusID],
	[cssnExpDays],
	[cssdFromDate],
	[cssdToDt],
	[csssComments],
	[cssnRecUserID],
	[cssdDtCreated],
	[cssnModifyUserID],
	[cssdDtModified],
	[cssnLevelNo],
	[cssnDelFlag]
)
SELECT
    CAS.casnCaseID 										as cssnCaseID
	,(
		select stpnStatusTypeID
		from sma_MST_CaseStatusType
		where stpsStatusType = 'Grade'
	)													as [cssnStatusTypeID]  -- Status Type 'Grade'
    ,( 
		select cssnStatusID
		from sma_MST_CaseStatus
		where csssDescription = d.Grade
	)													as [cssnStatusID]  		-- Status value
    ,''													as [cssnExpDays]
	,getdate()											as [cssdFromDate]
    ,null												as [cssdToDt]
    ,null												as [csssComments]
    ,368 												as cssnRecUserID
    ,getdate()											as [cssdDtCreated]
    ,null												as cssnModifyUserID
	,null												as cssdDtModified
	,null												as cssnLevelNo
	,null												as cssnDelFlag
from NeedlesSLF..user_case_data d
join [sma_trn_cases] CAS
	on cas.cassCaseNumber = convert(varchar,d.casenum)
where isnull(d.Grade,'') <> ''

alter table [sma_TRN_CaseStatus] enable trigger all
GO


---(2)---
ALTER TABLE [sma_trn_cases] DISABLE TRIGGER ALL
GO
---------
UPDATE sma_trn_cases set casnStatusValueID=STA.cssnStatusID
FROM sma_TRN_CaseStatus STA
WHERE STA.cssnCaseID=casnCaseID
GO

ALTER TABLE [sma_trn_cases] ENABLE TRIGGER ALL
GO


