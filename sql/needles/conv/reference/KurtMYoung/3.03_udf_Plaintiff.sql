use SANeedlesKMY
go

/* ####################################
0.0 -- Create Pivot Table
*/

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PlaintiffUDF' AND type = 'U')
BEGIN
    DROP TABLE PlaintiffUDF
END
GO

-- user_case_data
SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO PlaintiffUDF
FROM ( 
	SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [Employers_Premises]) as [Employer's Premises?],
        convert(varchar(max), [Incident_Reported]) as [Incident Reported?],
        convert(varchar(max), [EMS]) as [EMS?],
        convert(varchar(max), [Witnesses]) as [Witnesses],
        convert(varchar(max), [Temp_Employee]) as [Temp Employee?],
        convert(varchar(max), [Referral_Fee]) as [Referral Fee?],
        convert(varchar(max), [No_Show]) as [No Show],
        convert(varchar(max), [JURY]) as [JURY],
        convert(varchar(max), [NON_JURY]) as [NON JURY]
    FROM NeedlesKMY..user_case_data ud
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.casenum)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [Employer's Premises?], [Incident Reported?], [EMS?], [Witnesses], [Temp Employee?], [Referral Fee?], [No Show], [JURY], [NON JURY]
)) AS unpvt;
GO

-- user_tab_data
INSERT INTO PlaintiffUDF (casncaseid, casnorgcasetypeID, fieldTitle, FieldVal)
SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
FROM ( 
	SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [Comments]) as [Comments],
        convert(varchar(max), [Child_Support_$_Requested]) as [Child Support $ Requested],
        convert(varchar(max), [Custody_Requested_by]) as [Custody Requested by],
        convert(varchar(max), [Date_of_Birth]) as [Date of Birth],
        convert(varchar(max), [Grade_in_School]) as [Grade in School],
        convert(varchar(max), [If_Other_Describe]) as [If Other, Describe],
        convert(varchar(max), [Name_of_Child]) as [Name of Child],
        convert(varchar(max), [Since]) as [Since],
        convert(varchar(max), [Special_Needs]) as [Special Needs],
        convert(varchar(max), [Visitation_Details]) as [Visitation Details],
        convert(varchar(max), [Visitation_Requested_by]) as [Visitation Requested by],
        convert(varchar(max), [Lives_with_Whom]) as [Lives with Whom]
    FROM NeedlesKMY..user_tab_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [Comments], [Child Support $ Requested], [Custody Requested by], [Date of Birth], [Grade in School], [If Other, Describe], 
    [Name of Child], [Since], [Special Needs], [Visitation Details], [Visitation Requested by], [Lives with Whom]
)) AS unpvt;
GO

/* ####################################
1.0 -- Plaintiff UDF
*/

-- 1.1 // Create the Plaintiff UDF Definitions
alter table [sma_MST_UDFDefinition] disable trigger all
GO

INSERT INTO [sma_MST_UDFDefinition]
(
    [udfsUDFCtg]
	,[udfnRelatedPK]
	,[udfsUDFName]
	,[udfsScreenName]
	,[udfsType]
	,[udfsLength]
	,[udfbIsActive]
	,[udfshortName]
	,[udfsNewValues]
	,[udfnSortOrder]
)
SELECT DISTINCT 
    'C'													as [udfsUDFCtg]
	,CST.cstnCaseTypeID									as [udfnRelatedPK]
	,M.field_title										as [udfsUDFName]
	,'Plaintiff'										as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_case_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_case_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM PlaintiffUDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	--LEFT JOIN	(
	--				SELECT DISTINCT table_Name, column_name
	--				FROM [NeedlesKMY].[dbo].[document_merge_params]
	--				WHERE table_Name = 'user_case_data'
	--			) dmp
		--ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Plaintiff'
		AND def.[udfsType] = ucf.UDFType
AND def.udfnUDFID IS NULL
ORDER BY M.field_title
GO

ALTER TABLE [sma_MST_UDFDefinition] ENABLE TRIGGER ALL
GO

-- 1.2 // Insert the Plaintiff UDF Values
	-- [sma_trn_UDFValues].[udvnRelatedID] -> References Case ID 
	-- [sma_trn_UDFValues].[udvnSubRelatedID] -> References the Plaintiff or Defendant ID
ALTER TABLE sma_trn_udfvalues DISABLE TRIGGER ALL
GO

INSERT INTO [sma_TRN_UDFValues]
(
    [udvnUDFID]
	,[udvsScreenName]
	,[udvsUDFCtg]
	,[udvnRelatedID]
	,[udvnSubRelatedID]
	,[udvsUDFValue]
	,[udvnRecUserID]
	,[udvdDtCreated]
	,[udvnModifyUserID]
	,[udvdDtModified]
	,[udvnLevelNo]
)
SELECT 
    def.udfnUDFID				as [udvnUDFID],
	'Plaintiff'					as [udvsScreenName],
	'C'							as [udvsUDFCtg],
	udf.casnCaseID				as [udvnRelatedID],		-- case ID
	pln.plnnPlaintiffID			as [udvnSubRelatedID],	-- plaintiff ID
	udf.FieldVal				as [udvsUDFValue],
	368							as [udvnRecUserID],
	getdate()					as [udvdDtCreated],
	null						as [udvnModifyUserID],
	null						as [udvdDtModified],
	null						as [udvnLevelNo]
FROM PlaintiffUDF udf
	-- get PlaintiffID for [udvnSubRelatedID]
	--join sma_TRN_Cases cas
	--	on cas.casnCaseID = udf.casnCaseID
	--join IndvOrgContacts_Indexed ioc
	--	on udf.party_id = ioc.SAGA
	join sma_TRN_Plaintiff pln
		on pln.plnnCaseID = udf.casnCaseID

	-- get caseID for [udvnRelatedID]
	--join [NeedlesKMY].[dbo].user_case_data cd
	--	on udf.party_id = pd.party_id
	--join sma_TRN_Cases cas
	--	on convert(varchar, pd.case_id) = cas.cassCaseNumber

	-- only update Plaintiff UDF Definitions
	left join sma_MST_UDFDefinition def
	on def.udfnRelatedPK = udf.casnOrgCaseTypeID
	and def.udfsUDFName = FieldTitle
	and def.udfsScreenName = 'Plaintiff'
GO

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO



/* ####################################
2.0 - Defendant UDF
*/

-- 2.1 // Create the Defendant UDF Definitions
--alter table [sma_MST_UDFDefinition] disable trigger all
--GO

--INSERT INTO [sma_MST_UDFDefinition]
--(
--    [udfsUDFCtg]
--	,[udfnRelatedPK]
--	,[udfsUDFName]
--	,[udfsScreenName]
--	,[udfsType]
--	,[udfsLength]
--	,[udfbIsActive]
--	,[udfshortName]
--	,[udfsNewValues]
--	,[udfnSortOrder]
--)
--SELECT DISTINCT 
--    'C'													as [udfsUDFCtg]
--	,CST.cstnCaseTypeID									as [udfnRelatedPK]
--	,M.field_title										as [udfsUDFName]
--	,R.[SA Party]										as [udfsScreenName]
--	,ucf.UDFType										as [udfsType]
--	,ucf.field_len										as [udfsLength]
--	,1													as [udfbIsActive]
--	,'user_party_data_' + ucf.column_name				as [udfshortName]
--	,ucf.dropdownValues									as [udfsNewValues]
--	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
--FROM [sma_MST_CaseType] CST
--	JOIN CaseTypeMixture mix
--		ON mix.[SmartAdvocate Case Type] = cst.cstsType

--	JOIN [NeedlesKMY].[dbo].[user_party_matter] M
--		ON M.mattercode = mix.matcode
--		AND M.field_type <> 'label'

--	JOIN [PartyRoles] R
--		on R.[Needles Roles] = M.party_role

--	JOIN	(
--				SELECT DISTINCT	fieldTitle
--				FROM PlaintiffDefendantUDF
--			) vd
--		ON vd.FieldTitle = M.field_title

--	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
--		ON ucf.field_num = M.ref_num

--	LEFT JOIN [sma_MST_UDFDefinition] def
--		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
--		AND def.[udfsUDFName] = M.field_title
--		AND def.[udfsScreenName] = 'Defendant'
--		AND def.[udfsType] = ucf.UDFType
--where R.[SA Party]='Defendant'
--AND def.udfnUDFID IS NULL
--ORDER BY M.field_title
--GO

--ALTER TABLE [sma_MST_UDFDefinition] ENABLE TRIGGER ALL
--GO

-- 2.2 // Insert the Defendant UDF Values
--ALTER TABLE sma_trn_udfvalues DISABLE TRIGGER ALL
--GO

--INSERT INTO [sma_TRN_UDFValues]
--(
--    [udvnUDFID]
--	,[udvsScreenName]
--	,[udvsUDFCtg]
--	,[udvnRelatedID]
--	,[udvnSubRelatedID]
--	,[udvsUDFValue]
--	,[udvnRecUserID]
--	,[udvdDtCreated]
--	,[udvnModifyUserID]
--	,[udvdDtModified]
--	,[udvnLevelNo]
--)
--SELECT 
--    def.udfnUDFID				as [udvnUDFID],
--	'Defendant'					as [udvsScreenName],
--	'C'							as [udvsUDFCtg],
--	cas.casnCaseID				as [udvnRelatedID],
--	dfn.defnDefendentID			as [udvnSubRelatedID],
--	udf.FieldVal				as [udvsUDFValue],
--	368							as [udvnRecUserID],
--	getdate()					as [udvdDtCreated],
--	null						as [udvnModifyUserID],
--	null						as [udvdDtModified],
--	null						as [udvnLevelNo]
--FROM PlaintiffDefendantUDF udf
--	-- get DefendantID for [udvnSubRelatedID]
--	join IndvOrgContacts_Indexed ioc
--		on udf.party_id = ioc.SAGA
--	join sma_TRN_Defendants dfn
--		on ioc.SAGA = dfn.saga_party

--	-- get caseID for [udvnRelatedID]
--	join [NeedlesKMY].[dbo].user_party_data pd
--		on udf.party_id = pd.party_id
--	join sma_TRN_Cases cas
--		on convert(varchar, pd.case_id) = cas.cassCaseNumber

--	-- only update Defendant UDF Definitions
--	left join sma_MST_UDFDefinition def
--	on def.udfnRelatedPK = cas.casnOrgCaseTypeID
--	and def.udfsUDFName = FieldTitle
--	and def.udfsScreenName = 'Defendant'
--GO

--ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
--GO