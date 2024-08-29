-- use [SANeedlesSLF]
--go
/*
alter table [sma_TRN_Cases] disable trigger all
delete from [sma_TRN_Cases] 
DBCC CHECKIDENT ('[sma_TRN_Cases]', RESEED, 0); 
alter table [sma_TRN_Cases] enable trigger all
*/

-- (0.1) sma_MST_CaseGroup -----------------------------------------------------
-- Create a default case group for data that does not neatly fit elsewhere
IF NOT EXISTS
( 
	select *
	from [sma_MST_CaseGroup]
	where [cgpsDscrptn] = 'Needles'
)
BEGIN
	INSERT INTO [sma_MST_CaseGroup]
	(
		[cgpsCode]
		,[cgpsDscrptn]
		,[cgpnRecUserId]
		,[cgpdDtCreated]
		,[cgpnModifyUserID]
		,[cgpdDtModified]
		,[cgpnLevelNo]
		,[IncidentTypeID]
		,[LimitGroupStatuses]
	)
	SELECT 
		'FORCONVERSION'			as [cgpsCode]
		,'Needles'				as [cgpsDscrptn]
		,368					as [cgpnRecUserId]
		,getdate()				as [cgpdDtCreated]
		,null					as [cgpnModifyUserID]
		,null					as [cgpdDtModified]
		,null					as [cgpnLevelNo]
		,(
			select IncidentTypeID
			from [sma_MST_IncidentTypes]
			where Description = 'General Negligence'
		)						as [IncidentTypeID]
		,null					as [LimitGroupStatuses]
END
GO


-- (0.2) sma_MST_Offices -----------------------------------------------------
-- Create an office for conversion client
IF NOT EXISTS
(
	select *
	from [sma_mst_offices]
	where office_name = 'Skolrood Law Firm'
)
BEGIN
	INSERT INTO [sma_mst_offices]
	(
		[office_status]
		,[office_name]
		,[state_id]
		,[is_default]
		,[date_created]
		,[user_created]
		,[date_modified]
		,[user_modified]
		,[Letterhead]
		,[UniqueContactId]
		,[PhoneNumber]
	)
	SELECT 
		1			    			as [office_status]
		,'Skolrood Law Firm' 		as [office_name]
		,(
			select sttnStateID
			from sma_MST_States
			where sttsDescription = 'Virginia'
		)							as [state_id]
		,1			    			as [is_default]
		,getdate()	    			as [date_created]
		,'dsmith'					as [user_created]
		,getdate()	    			as [date_modified]
		,'dbo'		    			as [user_modified]
		,'LetterheadUt.docx' 		as [Letterhead]
		,NULL						as [UniqueContactId]
		,'4192447885'	    		as [PhoneNumber]
END
GO


-- (1) sma_MST_CaseType -----------------------------------------------------
-- (1.1) - Add a case type field that acts as conversion flag
-- for future reference: "VenderCaseType"
IF NOT EXISTS
(
	SELECT *
	FROM sys.columns
	WHERE Name = N'VenderCaseType'
	AND Object_ID = Object_ID(N'sma_MST_CaseType')
)
BEGIN
	ALTER TABLE sma_MST_CaseType
	ADD VenderCaseType varchar(100)
END
GO

-- (1.2) - Create case types from CaseTypeMixtures
INSERT INTO [sma_MST_CaseType]
(	   		
	[cstsCode],
	[cstsType],
	[cstsSubType],
	[cstnWorkflowTemplateID],
	[cstnExpectedResolutionDays],
	[cstnRecUserID],
	[cstdDtCreated],
	[cstnModifyUserID],
	[cstdDtModified],
	[cstnLevelNo],
	[cstbTimeTracking],
	[cstnGroupID],
	[cstnGovtMunType],
	[cstnIsMassTort],
	[cstnStatusID],
	[cstnStatusTypeID],
	[cstbActive],
	[cstbUseIncident1],
	[cstsIncidentLabel1],
	[VenderCaseType]
)
SELECT 
	NULL							as cstsCode
	,[SmartAdvocate Case Type]   	as cstsType
	,NULL							as cstsSubType
	,NULL							as cstnWorkflowTemplateID
	,720							as cstnExpectedResolutionDays 		-- ( Hardcode 2 years )
	,368							as cstnRecUserID
	,getdate()						as cstdDtCreated
	,368							as cstnModifyUserID
	,getdate()						as cstdDtModified
	,0								as cstnLevelNo
	,null							as cstbTimeTracking
    ,(
		select cgpnCaseGroupID
		from sma_MST_caseGroup
		where cgpsDscrptn='Needles'
	)								as cstnGroupID
    ,null							as cstnGovtMunType
    ,null							as cstnIsMassTort
	,(
		select cssnStatusID
		FROM [sma_MST_CaseStatus]
		where csssDescription='Presign - Not Scheduled For Sign Up'
	)								as cstnStatusID
	,(
		select stpnStatusTypeID
		FROM [sma_MST_CaseStatusType]
		where stpsStatusType='Status'
	)								as cstnStatusTypeID
	,1								as cstbActive
	,1								as cstbUseIncident1
	,'Incident 1'					as cstsIncidentLabel1
	,'SLFCaseType'					as VenderCaseType
FROM [CaseTypeMixture] MIX 
LEFT JOIN [sma_MST_CaseType] ct
	on ct.cststype = mix.[SmartAdvocate Case Type]
WHERE ct.cstncasetypeid IS NULL
GO

-- (1.3) - Add conversion flag to case types created above
UPDATE [sma_MST_CaseType] 
SET	VenderCaseType ='SLFCaseType'
FROM [CaseTypeMixture] MIX 
JOIN [sma_MST_CaseType] ct
	on ct.cststype = mix.[SmartAdvocate Case Type]
WHERE isnull(VenderCaseType,'') = ''
GO
	
-- (2) sma_MST_CaseSubType -----------------------------------------------------
-- (2.1) - sma_MST_CaseSubTypeCode
-- For non-null values of SA Case Sub Type from CaseTypeMixture,
-- add distinct values to CaseSubTypeCode and populate stcsDscrptn
INSERT INTO [dbo].[sma_MST_CaseSubTypeCode]
(
	stcsDscrptn 
)
SELECT DISTINCT MIX.[SmartAdvocate Case Sub Type]
FROM [CaseTypeMixture] MIX 
WHERE isnull(MIX.[SmartAdvocate Case Sub Type],'') <> ''
EXCEPT
SELECT
	stcsDscrptn
	from [dbo].[sma_MST_CaseSubTypeCode]
GO

-- (2.2) - sma_MST_CaseSubType
-- Construct CaseSubType using CaseTypes
INSERT INTO [sma_MST_CaseSubType]
(
	[cstsCode], 
	[cstnGroupID], 
	[cstsDscrptn], 
	[cstnRecUserId], 
	[cstdDtCreated], 
	[cstnModifyUserID], 
	[cstdDtModified], 
	[cstnLevelNo], 
	[cstbDefualt], 
	[saga], 
	[cstnTypeCode]
)
SELECT  
	null								as [cstsCode]
	,cstncasetypeid						as [cstnGroupID]
	,[SmartAdvocate Case Sub Type]		as [cstsDscrptn]
	,368 								as [cstnRecUserId]
	,getdate()							as [cstdDtCreated]
	,null								as [cstnModifyUserID]
	,null								as [cstdDtModified]
	,null								as [cstnLevelNo]
	,1									as [cstbDefualt]
	,null								as [saga]
	,(
		select stcnCodeId
		from [sma_MST_CaseSubTypeCode]
		where stcsDscrptn = [SmartAdvocate Case Sub Type]
	)									as [cstnTypeCode] 
FROM [sma_MST_CaseType] CST
JOIN [CaseTypeMixture] MIX
	on MIX.[SmartAdvocate Case Type] = CST.cststype
LEFT JOIN [sma_MST_CaseSubType] sub
	on sub.[cstnGroupID] = cstncasetypeid
	and sub.[cstsDscrptn] = [SmartAdvocate Case Sub Type]
WHERE sub.cstncasesubtypeID is null
and isnull([SmartAdvocate Case Sub Type],'') <> ''

/* ########################################################
Create Case Types from user_case_data.type_of_case that don't already exist
*/
INSERT INTO [sma_MST_CaseType]
(	   		
	[cstsCode],
	[cstsType],
	[cstsSubType],
	[cstnWorkflowTemplateID],
	[cstnExpectedResolutionDays],
	[cstnRecUserID],
	[cstdDtCreated],
	[cstnModifyUserID],
	[cstdDtModified],
	[cstnLevelNo],
	[cstbTimeTracking],
	[cstnGroupID],
	[cstnGovtMunType],
	[cstnIsMassTort],
	[cstnStatusID],
	[cstnStatusTypeID],
	[cstbActive],
	[cstbUseIncident1],
	[cstsIncidentLabel1],
	[VenderCaseType]
)
SELECT DISTINCT
	NULL							as cstsCode
	,d.Type_of_Case				   	as cstsType
	,NULL							as cstsSubType
	,NULL							as cstnWorkflowTemplateID
	,720							as cstnExpectedResolutionDays 		-- ( Hardcode 2 years )
	,368							as cstnRecUserID
	,getdate()						as cstdDtCreated
	,368							as cstnModifyUserID
	,getdate()						as cstdDtModified
	,0								as cstnLevelNo
	,null							as cstbTimeTracking
    ,(
		select cgpnCaseGroupID
		from sma_MST_caseGroup
		where cgpsDscrptn = 'Needles'
	)								as cstnGroupID
    ,null							as cstnGovtMunType
    ,null							as cstnIsMassTort
	,(
		select cssnStatusID
		FROM [sma_MST_CaseStatus]
		where csssDescription = 'Presign - Not Scheduled For Sign Up'
	)								as cstnStatusID
	,(
		select stpnStatusTypeID
		FROM [sma_MST_CaseStatusType]
		where stpsStatusType = 'Status'
	)								as cstnStatusTypeID
	,1								as cstbActive
	,1								as cstbUseIncident1
	,'Incident 1'					as cstsIncidentLabel1
	,'SLFCaseType'					as VenderCaseType
FROM [NeedlesSLF]..user_case_data d
LEFT JOIN [sma_MST_CaseType] ct
	ON d.Type_of_Case = ct.cstsType
WHERE ct.cstsType IS NULL and isnull(d.Type_of_Case,'') <> ''
GO

/* ########################################################
Create SubTypeCodes 
*/
INSERT INTO [dbo].[sma_MST_CaseSubTypeCode]
(
	stcsDscrptn 
)
SELECT DISTINCT d.Type_of_Accident
from [NeedlesSLF]..user_case_data d
where isnull(d.Type_of_Accident,'') <> ''
EXCEPT
SELECT
	stcsDscrptn
	from [dbo].[sma_MST_CaseSubTypeCode]
GO

/* ########################################################
Create SubTypes
Add subtypes to case type "Auto Accident" with data from user_case_data.type_of_accident
*/
INSERT INTO [sma_MST_CaseSubType]
(
	[cstsCode], 
	[cstnGroupID], 
	[cstsDscrptn], 
	[cstnRecUserId], 
	[cstdDtCreated], 
	[cstnModifyUserID], 
	[cstdDtModified], 
	[cstnLevelNo], 
	[cstbDefualt], 
	[saga], 
	[cstnTypeCode]
)
SELECT distinct
	null								as [cstsCode]
	,(
		select cstnCaseTypeID
		from sma_MST_CaseType
		where cstsType = 'Auto Accident'
	)									as [cstnGroupID]
	,d.Type_of_Accident					as [cstsDscrptn]
	,368 								as [cstnRecUserId]
	,getdate()							as [cstdDtCreated]
	,null								as [cstnModifyUserID]
	,null								as [cstdDtModified]
	,null								as [cstnLevelNo]
	,1									as [cstbDefualt]
	,null								as [saga]
	,(
		select stcnCodeId
		from [sma_MST_CaseSubTypeCode]
		where stcsDscrptn = d.Type_of_Accident
	)									as [cstnTypeCode] 
from [NeedlesSLF]..user_case_data d
where isnull(d.Type_of_Accident,'') <> ''


/*
---(2.2) sma_MST_CaseSubType
insert into [sma_MST_CaseSubType]
(
       [cstsCode]
      ,[cstnGroupID]
      ,[cstsDscrptn]
      ,[cstnRecUserId]
      ,[cstdDtCreated]
      ,[cstnModifyUserID]
      ,[cstdDtModified]
      ,[cstnLevelNo]
      ,[cstbDefualt]
      ,[saga]
      ,[cstnTypeCode]
)
select  	null				as [cstsCode],
		cstncasetypeid		as [cstnGroupID],
		MIX.[SmartAdvocate Case Sub Type] as [cstsDscrptn], 
		368 				as [cstnRecUserId],
		getdate()			as [cstdDtCreated],
		null				as [cstnModifyUserID],
		null				as [cstdDtModified],
		null				as [cstnLevelNo],
		1				as [cstbDefualt],
		null				as [saga],
		(select stcnCodeId from [sma_MST_CaseSubTypeCode] where stcsDscrptn=MIX.[SmartAdvocate Case Sub Type]) as [cstnTypeCode] 
FROM [sma_MST_CaseType] CST 
JOIN [CaseTypeMixture] MIX on MIX.matcode=CST.cstsCode  
LEFT JOIN [sma_MST_CaseSubType] sub on sub.[cstnGroupID] = cstncasetypeid and sub.[cstsDscrptn] = MIX.[SmartAdvocate Case Sub Type]
WHERE isnull(MIX.[SmartAdvocate Case Type],'')<>''
and sub.cstncasesubtypeID is null
*/


-- (3.0) sma_MST_SubRole -----------------------------------------------------
INSERT INTO [sma_MST_SubRole]
(
	[sbrsCode]
	,[sbrnRoleID]
	,[sbrsDscrptn]
	,[sbrnCaseTypeID]
	,[sbrnPriority]
	,[sbrnRecUserID]
	,[sbrdDtCreated]
	,[sbrnModifyUserID]
	,[sbrdDtModified]
	,[sbrnLevelNo]
	,[sbrbDefualt]
	,[saga]
)
SELECT 
	[sbrsCode]					as [sbrsCode]
	,[sbrnRoleID]				as [sbrnRoleID]
	,[sbrsDscrptn]				as [sbrsDscrptn]
	,CST.cstnCaseTypeID			as [sbrnCaseTypeID]
	,[sbrnPriority]				as [sbrnPriority]
	,[sbrnRecUserID]			as [sbrnRecUserID]
	,[sbrdDtCreated]			as [sbrdDtCreated]
	,[sbrnModifyUserID]			as [sbrnModifyUserID]
	,[sbrdDtModified]			as [sbrdDtModified]
	,[sbrnLevelNo]				as [sbrnLevelNo]
	,[sbrbDefualt]				as [sbrbDefualt]
	,[saga]						as [saga] 
FROM sma_MST_CaseType CST
LEFT JOIN sma_mst_subrole S
	on CST.cstnCaseTypeID = S.sbrnCaseTypeID or S.sbrnCaseTypeID = 1
JOIN [CaseTypeMixture] MIX
	on MIX.matcode = CST.cstsCode  
WHERE VenderCaseType = 'SLFCaseType'
and isnull(MIX.[SmartAdvocate Case Type],'') = ''

-- (3.1) sma_MST_SubRole : use the sma_MST_SubRole.sbrsDscrptn value to set the sma_MST_SubRole.sbrnTypeCode field ---
UPDATE sma_MST_SubRole
SET sbrnTypeCode = A.CodeId
FROM
(
	SELECT
		S.sbrsDscrptn		as sbrsDscrptn
		,S.sbrnSubRoleId	as SubRoleId
		,(
			select max(srcnCodeId)
			from sma_MST_SubRoleCode
			where srcsDscrptn = S.sbrsDscrptn
		) 					as CodeId
	FROM sma_MST_SubRole S
	JOIN sma_MST_CaseType CST
		on CST.cstnCaseTypeID = S.sbrnCaseTypeID
		and CST.VenderCaseType = 'SLFCaseType'
) A
WHERE A.SubRoleId = sbrnSubRoleId


-- (4) specific plaintiff and defendant party roles ----------------------------------------------------
INSERT INTO [sma_MST_SubRoleCode]
(
	srcsDscrptn
	,srcnRoleID 
)
(
	SELECT '(P)-Default Role', 4

	UNION ALL

	SELECT '(D)-Default Role', 5

	UNION ALL

	SELECT [SA Roles], 4
	FROM [PartyRoles]
	WHERE [SA Party] = 'Plaintiff'

	UNION ALL

	SELECT [SA Roles], 5
	FROM [PartyRoles]
	WHERE [SA Party]='Defendant'
)
EXCEPT
SELECT
	srcsDscrptn
	,srcnRoleID
FROM [sma_MST_SubRoleCode]


-- (4.1) Not already in sma_MST_SubRole-----
INSERT INTO sma_MST_SubRole ( sbrnRoleID,sbrsDscrptn,sbrnCaseTypeID,sbrnTypeCode)

SELECT T.sbrnRoleID,T.sbrsDscrptn,T.sbrnCaseTypeID,T.sbrnTypeCode
FROM 
(	SELECT 
		R.PorD			    as sbrnRoleID,
		R.[role]			    as sbrsDscrptn,
		CST.cstnCaseTypeID	    as sbrnCaseTypeID,
		(select srcnCodeId from sma_MST_SubRoleCode where srcsDscrptn = R.role and srcnRoleID = R.PorD) as sbrnTypeCode
	FROM sma_MST_CaseType CST
CROSS JOIN 
(
	SELECT '(P)-Default Role' as role, 4 as PorD
		UNION ALL
	SELECT '(D)-Default Role' as role, 5 as PorD
		UNION ALL
	SELECT [SA Roles]  as role, 4 as PorD from [PartyRoles] where [SA Party]='Plaintiff'
		UNION ALL
	SELECT [SA Roles]  as role, 5 as PorD from [PartyRoles] where [SA Party]='Defendant'
) R
WHERE CST.VenderCaseType='SLFCaseType'
) T
EXCEPT SELECT sbrnRoleID,sbrsDscrptn,sbrnCaseTypeID,sbrnTypeCode FROM sma_MST_SubRole



/* 
---Checking---
SELECT CST.cstnCaseTypeID,CST.cstsType,sbrsDscrptn
FROM sma_MST_SubRole S
INNER JOIN sma_MST_CaseType CST on CST.cstnCaseTypeID=S.sbrnCaseTypeID
WHERE CST.VenderCaseType='SLFCaseType'
and sbrsDscrptn='(D)-Default Role'
ORDER BY CST.cstnCaseTypeID
*/


-------- (5) sma_TRN_cases ----------------------
ALTER TABLE [sma_TRN_Cases] DISABLE TRIGGER ALL
GO

INSERT INTO [sma_TRN_Cases]
( 
  [cassCaseNumber]
  ,[casbAppName]
  ,[cassCaseName]
  ,[casnCaseTypeID]
  ,[casnState]
  ,[casdStatusFromDt]
  ,[casnStatusValueID]
  ,[casdsubstatusfromdt]
  ,[casnSubStatusValueID]
  ,[casdOpeningDate]
  ,[casdClosingDate]
  ,[casnCaseValueID]
  ,[casnCaseValueFrom]
  ,[casnCaseValueTo]
  ,[casnCurrentCourt]
  ,[casnCurrentJudge]
  ,[casnCurrentMagistrate]
  ,[casnCaptionID]
  ,[cassCaptionText]
  ,[casbMainCase]
  ,[casbCaseOut]
  ,[casbSubOut]
  ,[casbWCOut]
  ,[casbPartialOut]
  ,[casbPartialSubOut]
  ,[casbPartiallySettled]
  ,[casbInHouse]
  ,[casbAutoTimer]
  ,[casdExpResolutionDate]
  ,[casdIncidentDate]
  ,[casnTotalLiability]
  ,[cassSharingCodeID]
  ,[casnStateID]
  ,[casnLastModifiedBy]
  ,[casdLastModifiedDate]
  ,[casnRecUserID]
  ,[casdDtCreated]
  ,[casnModifyUserID]
  ,[casdDtModified]
  ,[casnLevelNo]
  ,[cassCaseValueComments]
  ,[casbRefIn]
  ,[casbDelete]
  ,[casbIntaken]
  ,[casnOrgCaseTypeID]
  ,[CassCaption]
  ,[cassMdl]
  ,[office_id]
  ,[saga]
  ,[LIP]
  ,[casnSeriousInj]
  ,[casnCorpDefn]
  ,[casnWebImporter]
  ,[casnRecoveryClient]
  ,[cas]
  ,[ngage]
  ,[casnClientRecoveredDt]
  ,[CloseReason]
)
SELECT 
    C.casenum						as cassCaseNumber
    ,'' 							as casbAppName
    ,case_title						as cassCaseName
	,(
		select cstnCaseSubTypeID
		from [sma_MST_CaseSubType] ST
		where ST.cstnGroupID = CST.cstnCaseTypeID
		and ST.cstsDscrptn = MIX.[SmartAdvocate Case Sub Type]
	)								as casnCaseTypeID
    ,(
		select [sttnStateID]
		from [sma_MST_States]
		where [sttsDescription] = 'Virginia'
	)								as casnState
    ,GETDATE()						as casdStatusFromDt
    ,(
		select cssnStatusID 
		FROM [sma_MST_CaseStatus]
		where csssDescription = 'Presign - Not Scheduled For Sign Up'
	)								as casnStatusValueID
    ,GETDATE()						as casdsubstatusfromdt
    ,(
		select cssnStatusID
		FROM [sma_MST_CaseStatus]
		where csssDescription = 'Presign - Not Scheduled For Sign Up'
	)								as casnSubStatusValueID
    ,case
		when (C.date_opened not between '1900-01-01' and '2079-12-31')
			then getdate() 
		else C.date_opened
		end							as casdOpeningDate
    ,case
		when (C.close_date not between '1900-01-01' and '2079-12-31')
			then getdate()
		else C.close_date
		end							as casdClosingDate
	,null							as [casnCaseValueID]
	,null							as [casnCaseValueFrom]
	,null							as [casnCaseValueTo]
	,null							as [casnCurrentCourt]
	,null							as [casnCurrentJudge]
	,null							as [casnCurrentMagistrate]
	,0								as [casnCaptionID]
	,case_title						as cassCaptionText
	,1 								as [casbMainCase]
	,0 								as [casbCaseOut]
	,0 								as [casbSubOut]
	,0 								as [casbWCOut]
	,0 								as [casbPartialOut]
	,0 								as [casbPartialSubOut]
	,0 								as [casbPartiallySettled]
	,1 								as [casbInHouse]
	,null							as [casbAutoTimer]
	,null							as [casdExpResolutionDate]
	,null							as [casdIncidentDate]
	,0 								as [casnTotalLiability]
	,0 								as [cassSharingCodeID]
    ,(
		select [sttnStateID]
		from [sma_MST_States]
		where [sttsDescription]='Virginia'
	)								as [casnStateID]
    ,null 							as [casnLastModifiedBy]
	,null 							as [casdLastModifiedDate]
    ,(
		select usrnUserID
		from sma_MST_Users
		where saga = C.intake_staff
	)								as casnRecUserID
    ,case
		when C.intake_date between '1900-01-01' and '2079-06-06' and C.intake_time between '1900-01-01' and '2079-06-06' 
			THEN (select cast(convert(date,C.intake_date) as datetime) + cast(convert(time,C.intake_time) as datetime))
		else null 
		end							as casdDtCreated
    ,null 							as casnModifyUserID
	,null 							as casdDtModified
	,'' 							as casnLevelNo
	,'' 							as cassCaseValueComments
	,null 							as casbRefIn
	,null 							as casbDelete
	,null 							as casbIntaken
    ,cstnCaseTypeID					as casnOrgCaseTypeID -- actual case type
    ,''								as CassCaption
    ,0								as cassMdl
    ,(
		select office_id
		from sma_MST_Offices
		where office_name = 'Skolrood Law Firm'
	)								as office_id
    ,''								as [saga]
	,null 							as [LIP]
	,null 							as [casnSeriousInj]
	,null 							as [casnCorpDefn]
	,null 							as [casnWebImporter]
	,null 							as [casnRecoveryClient]
	,null 							as [cas]
	,null 							as [ngage]
	,null 							as [casnClientRecoveredDt]
    ,0								as CloseReason
FROM [NeedlesSLF].[dbo].[cases_Indexed] C
LEFT JOIN [NeedlesSLF].[dbo].[user_case_data] U
	on U.casenum=C.casenum
JOIN caseTypeMixture mix
	on mix.matcode = c.matcode
LEFT JOIN sma_MST_CaseType CST
	on CST.cststype = mix.[smartadvocate Case Type]
	and VenderCaseType='SLFCaseType'
ORDER BY C.casenum
GO

---
ALTER TABLE [sma_TRN_Cases] ENABLE TRIGGER ALL
GO
---
