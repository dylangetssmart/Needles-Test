USE SANeedlesKMY
GO


--select * From NeedlesKMY..case_intake order by intake_taken
--sp_help sma_trn_Cases

ALTER TABLE sma_trn_Cases
ALTER COLUMN saga int
GO


INSERT INTO [dbo].[CaseTypeMixture](
	[matcode],
	[header],
	[description],
	[SmartAdvocate Case Type],
	[SmartAdvocate Case Sub Type]
)
SELECT '', '', '', 'Negligence', 'Unknown'
EXCEPT SELECT [matcode],[header],[description], [SmartAdvocate Case Type],[SmartAdvocate Case Sub Type] FROM CaseTypeMixture

--select * from [CaseTypeMixture]
----------------------------
--CASE SUB TYPES
----------------------------
INSERT INTO [sma_MST_CaseSubType]
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
SELECT 
	null				as [cstsCode]
	,cstncasetypeid		as [cstnGroupID]
	,MIX.[SmartAdvocate Case Sub Type] as [cstsDscrptn]
	,368 				as [cstnRecUserId]
	,getdate()			as [cstdDtCreated]
	,null				as [cstnModifyUserID]
	,null				as [cstdDtModified]
	,null				as [cstnLevelNo]
	,1					as [cstbDefualt]
	,null				as [saga]
	,(
		select stcnCodeId
		from [sma_MST_CaseSubTypeCode]
		where stcsDscrptn=MIX.[SmartAdvocate Case Sub Type]
	)					as [cstnTypeCode]
--select mix.*
FROM [sma_MST_CaseType] CST 
	JOIN [CaseTypeMixture] MIX 
		on isnull(mix.[SmartAdvocate Case Type],'') = isnull(cst.cstsType,'') --MIX.matcode=CST.cstsCode  
	LEFT JOIN [sma_MST_CaseSubType] sub
		on sub.[cstnGroupID] = cst.cstncasetypeid
		and isnull(sub.[cstsDscrptn],'') = isnull(mix.[SmartAdvocate Case Sub Type],'')
WHERE isnull(MIX.[SmartAdvocate Case Type],'')<>''
	and sub.cstncasesubtypeid is null
	and  isnull([SmartAdvocate Case Sub Type],'') <> ''


---------------------------------------
--INSERT INTAKE INTO CASES
---------------------------------------
DECLARE @OfficeName NVARCHAR(255);
DECLARE @StateAbbrv NVARCHAR(255);
SET @OfficeName = 'Law Offices of Kurt M. Young, LLC';
SET @StateAbbrv = 'Ohio'

INSERT INTO [sma_TRN_Cases]
( 
  [cassCaseNumber],[casbAppName],[cassCaseName],[casnCaseTypeID],[casnState],[casdStatusFromDt],[casnStatusValueID],[casdsubstatusfromdt],[casnSubStatusValueID],[casdOpeningDate],
  [casdClosingDate],[casnCaseValueID],[casnCaseValueFrom],[casnCaseValueTo],[casnCurrentCourt],[casnCurrentJudge],[casnCurrentMagistrate],[casnCaptionID],[cassCaptionText],
  [casbMainCase],[casbCaseOut],[casbSubOut],[casbWCOut],[casbPartialOut],[casbPartialSubOut],[casbPartiallySettled],[casbInHouse],[casbAutoTimer],[casdExpResolutionDate],
  [casdIncidentDate],[casnTotalLiability],[cassSharingCodeID],[casnStateID],[casnLastModifiedBy],[casdLastModifiedDate],[casnRecUserID],[casdDtCreated],[casnModifyUserID],
  [casdDtModified],[casnLevelNo],[cassCaseValueComments],[casbRefIn],[casbDelete],[casbIntaken],[casnOrgCaseTypeID],[CassCaption],[cassMdl],[office_id],[saga],
  [LIP],[casnSeriousInj],[casnCorpDefn],[casnWebImporter],[casnRecoveryClient],[cas],[ngage],[casnClientRecoveredDt],[CloseReason]
)
SELECT DISTINCT
     'Intake ' + RIGHT('00000' + CONVERT(VARCHAR, row_ID), 5)      AS [cassCaseNumber]
    ,''                                                           AS [casbAppName]
    ,''                                                           AS [cassCaseName]
    ,(
        SELECT TOP 1 cstnCaseSubTypeID
        FROM [sma_MST_CaseSubType] ST
        WHERE ST.cstnGroupID = CST.cstnCaseTypeID AND ST.cstsDscrptn = MIX.[SmartAdvocate Case Sub Type]
    )                                                             AS [casnCaseTypeID]
    ,(
        SELECT [sttnStateID]
        FROM [sma_MST_States]
        WHERE [sttsDescription] = @StateAbbrv
    )                                                             AS [casnState]
    ,ISNULL(date_rejected, GETDATE())                             AS [casdStatusFromDt]
    ,NULL                                                         AS [casnStatusValueID]
    ,NULL                                                         AS [casdsubstatusfromdt]
    ,NULL                                                         AS [casnSubStatusValueID]
    ,CASE
        WHEN (C.intake_taken NOT BETWEEN '1900-01-01' AND '2079-12-31')
            THEN GETDATE()
        ELSE C.intake_taken
    END                                                          AS [casdOpeningDate]
    ,CASE
        WHEN (C.date_rejected BETWEEN '1900-01-01' AND '2079-12-31')
            THEN C.date_rejected
        ELSE NULL
    END                                                          AS [casdClosingDate]
    ,NULL                                                         AS [casnCaseValueID]
    ,NULL                                                         AS [casnCaseValueFrom]
    ,NULL                                                         AS [casnCaseValueTo]
    ,NULL                                                         AS [casnCurrentCourt]
    ,NULL                                                         AS [casnCurrentJudge]
    ,NULL                                                         AS [casnCurrentMagistrate]
    ,NULL                                                         AS [casnCaptionID]
    ,''                                                           AS [cassCaptionText]
    ,1                                                            AS [casbMainCase]
    ,0                                                            AS [casbCaseOut]
    ,0                                                            AS [casbSubOut]
    ,0                                                            AS [casbWCOut]
    ,0                                                            AS [casbPartialOut]
    ,0                                                            AS [casbPartialSubOut]
    ,0                                                            AS [casbPartiallySettled]
    ,0                                                            AS [casbInHouse]
    ,1                                                            AS [casbAutoTimer]
    ,NULL                                                         AS [casdExpResolutionDate]
    ,NULL                                                         AS [casdIncidentDate]
    ,NULL                                                         AS [casnTotalLiability]
    ,NULL                                                         AS [cassSharingCodeID]
    ,(
        SELECT [sttnStateID]
        FROM [sma_MST_States]
        WHERE [sttsDescription] = @StateAbbrv
    )                                                             AS [casnStateID]
    ,NULL                                                         AS [casnLastModifiedBy]
    ,NULL                                                         AS [casdLastModifiedDate]
    ,(
        SELECT usrnUserID
        FROM sma_MST_Users
        WHERE saga = C.Taken_by
    )                                                             AS [casnRecUserID]
    ,CASE
        WHEN (C.intake_taken BETWEEN '1900-01-01' AND '2079-06-06')
            THEN C.intake_taken
        ELSE NULL
    END															AS [casdDtCreated]
    ,NULL                                                         AS [casnModifyUserID]
    ,NULL                                                         AS [casdDtModified]
    ,0                                                            AS [casnLevelNo]
    ,''                                                           AS [cassCaseValueComments]
    ,NULL                                                         AS [casbRefIn]
    ,NULL                                                         AS [casbDelete]
    ,NULL                                                         AS [casbIntaken]
    ,cstnCaseTypeID                                               AS [casnOrgCaseTypeID]
    ,''                                                           AS [CassCaption]
    ,0                                                            AS [cassMdl]
    ,(
        SELECT office_id
        FROM sma_MST_Offices
        WHERE office_name = @OfficeName
    )                                                             AS [office_id]
    ,ROW_ID                                                       AS [saga]
    ,NULL                                                         AS [LIP]
    ,NULL                                                         AS [casnSeriousInj]
    ,NULL                                                         AS [casnCorpDefn]
    ,NULL                                                         AS [casnWebImporter]
    ,NULL                                                         AS [casnRecoveryClient]
    ,NULL                                                         AS [cas]
    ,NULL                                                         AS [ngage]
    ,NULL                                                         AS [casnClientRecoveredDt]
    ,0                                                            AS [CloseReason]
FROM NeedlesKMY.[dbo].[Case_intake] C
    LEFT JOIN [CaseTypeMixture] MIX
        ON MIX.matcode = REPLACE(C.matcode, ' ', '')
    LEFT JOIN sma_MST_CaseType CST
        ON ISNULL(CST.cstsType, '') = ISNULL(MIX.[SmartAdvocate Case Type], '') 
WHERE ISNULL(name_ID, '') <> ''


--select * FROM NeedlesKMY.[dbo].[Case_intake] C

------------------------------------------
--INTAKE STATUS
------------------------------------------
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
    CAS.casnCaseID,
    (select stpnStatusTypeID from sma_MST_CaseStatusType where stpsStatusType='Status') as [cssnStatusTypeID],
    case
	   when C.date_rejected between '1900-01-01' and '2079-06-06' 
		  then (select cssnStatusID from sma_MST_CaseStatus where csssDescription='Closed Case')
	   else (select cssnStatusID from sma_MST_CaseStatus where csssDescription='Presign - Not scheduled for Sign Up')
    end		 as [cssnStatusID],
    ''		 as [cssnExpDays],
    case when C.date_rejected between '1900-01-01' and '2079-06-06' 
		 then convert(date,C.date_rejected)   
	   else getdate()    end		 as [cssdFromDate],
    null		 as [cssdToDt],
    case when date_rejected is not null then 'Rejected' else '' end		 as [csssComments],
    368,
    GETDATE(),
    null,null,null,null 
FROM [sma_trn_cases] CAS
JOIN NeedlesKMY..case_intake C on C.ROW_ID = CAS.saga
GO

------------------------------
--INCIDENT
------------------------------
---
-- ALTER TABLE [sma_TRN_Incidents] DISABLE TRIGGER ALL
-- GO
-- ALTER TABLE [sma_TRN_Cases] DISABLE TRIGGER ALL
-- GO
-- ---
-- INSERT INTO [sma_TRN_Incidents] (
-- 		[CaseId],
-- 		[IncidentDate],
-- 		[StateID],
-- 		[LiabilityCodeId],
-- 		[IncidentFacts],
-- 		[MergedFacts],
-- 		[Comments],
-- 		[IncidentTime],
-- 		[RecUserID],
-- 		[DtCreated],
-- 		[ModifyUserID],
-- 		[DtModified]
-- )
-- SELECT 
-- 		CAS.casnCaseID		  as CaseId,
-- 		case when ( C.[date_of_incident] between '1900-01-01' and '2079-06-06' ) then convert(date,C.[date_of_incident]) 
-- 			else null end 	  as IncidentDate,
-- 		(select sttnStateID from sma_MST_States where sttsCode='OH')	as [StateID],
-- 		0					 as LiabilityCodeId, 
-- 		C.synopsis			 as IncidentFacts,
-- 		''					 as [MergedFacts],
-- 		null				 as [Comments],
-- 		null				 as [IncidentTime],
-- 		368					 as [RecUserID],
-- 		getdate()			 as [DtCreated],
-- 		null				 as [ModifyUserID],
-- 		null				 as [DtModified]
-- --Select *
-- FROM NeedlesKMY..case_intake C
-- JOIN [sma_TRN_cases] CAS on C.ROW_ID = CAS.saga 


-- UPDATE CAS
-- SET CAS.casdIncidentDate=INC.IncidentDate,
--     CAS.casnStateID=INC.StateID,
--     CAS.casnState=INC.StateID
-- FROM sma_trn_cases as CAS
-- LEFT JOIN sma_TRN_Incidents as INC on casnCaseID=caseid
-- WHERE INC.CaseId=CAS.casncaseid 

---
ALTER TABLE [sma_TRN_Incidents] ENABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Cases] ENABLE TRIGGER ALL
GO
--

----------------------------
----INCIDENT LOCATION
----------------------------
----INCIDENT LOCATION UDF IF NOT EXISTS
--INSERT INTO [dbo].[sma_MST_UDFDefinition] (
--		[udfsUDFCtg],
--		[udfnRelatedPK],
--		[udfsUDFName],
--		[udfsScreenName],
--		[udfsType],
--		[udfsLength],
--		[udfsFormat],
--		[udfsTableName],
--		[udfsNewValues],
--		[udfsDefaultValue],
--		[udfnSortOrder],
--		[udfbIsActive],
--		[udfnRecUserID],
--		[udfnDtCreated],
--		[udfnModifyUserID],
--		[udfnDtModified],
--		[udfnLevelNo],
--		[udfbIsSystem],
--		[UdfShortName],
--		[DisplayInSingleColumn]  )
--SELECT DISTINCT 
--		'C'						as [udfsUDFCtg],
--		casnOrgCaseTypeID		as [udfnRelatedPK],
--		'Location'				as [udfsUDFName],
--		'Incident Wizard'		as [udfsScreenName],
--		'Text'					as [udfsType],
--		100						as [udfsLength],
--		null,null,null,null,
--		0						as [udfnSortOrder],
--		1						as [udfbIsActive],
--		368						as [udfnRecUserID],
--		getdate()				as [udfnDtCreated],
--		null,null,0,0,null,0 
--FROM sma_trn_Cases CAS 
--LEFT JOIN sma_MST_UDFDefinition UD on UD.udfnRelatedPK=cas.casnOrgCaseTypeID and UD.udfsScreenName='Incident Wizard' and udfsUDFName= 'Location'
--WHERE UD.udfnUDFID IS NULL
--and cas.cassCaseNumber like 'Intake%'
--and isnull(casnOrgCaseTypeID,'') <> ''

----------------------------
-----LOCATION UDF VALUES---
----------------------------
--INSERT INTO [sma_TRN_UDFValues] (
--       [udvnUDFID]
--      ,[udvsScreenName]
--      ,[udvsUDFCtg]
--      ,[udvnRelatedID]
--      ,[udvnSubRelatedID]
--      ,[udvsUDFValue]
--      ,[udvnRecUserID]
--      ,[udvdDtCreated]
--      ,[udvnModifyUserID]
--      ,[udvdDtModified]
--      ,[udvnLevelNo]
--)
--SELECT DISTINCT
--    (select udfnUDFID from sma_MST_UDFDefinition 
--	   where udfnRelatedPK= cas.casnOrgCaseTypeID
--	   and udfsScreenName='Incident Wizard'
--	   and udfsUDFName='Location')
--    						  as [udvnUDFID],
--    'Incident Wizard'		  as [udvsScreenName],
--    'I'						  as [udvsUDFCtg],
--    CAS.casnCaseID			  as [udvnRelatedID],
--    0						  as[udvnSubRelatedID],
--    convert(varchar(max),c.Location_Case)			  as [udvsUDFValue], 
--    368						  as [udvnRecUserID],
--    getdate()				  as [udvdDtCreated],
--    null					  as [udvnModifyUserID],
--    null					  as [udvdDtModified],
--    null					  as [udvnLevelNo]
--FROM [sma_TRN_Cases] CAS
--JOIN NeedlesKMY..case_intake C on C.ROW_ID = CAS.saga 
--WHERE isnull(convert(varchar(max),c.Location_Case),'')<>''
