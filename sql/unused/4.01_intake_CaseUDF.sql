-- use SANeedlesSLF
go

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CaseIntakeUDF' AND type = 'U')
BEGIN
    DROP TABLE CaseIntakeUDF
END

/* ####################################
1.0 - Build CaseIntakeUDF from case_intake
*/

SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO CaseIntakeUDF
FROM ( 
    SELECT C.casnCaseID, C.CasnOrgCaseTypeID, 
        convert(varchar(max), [SSISSDI_Case]) as [SSI/SSDI], 
        convert(varchar(max), [Date_Last_Worked_Case]) as [Date Last Worked], 
        convert(varchar(max), [Doctor_Support_Claim_Case]) as [Doctor Support Claim?], 
        convert(varchar(max), [Status_Upon_Intake_Case]) as [Status Upon Intake], 
        convert(varchar(max), [Treatment_Since_Injury_Case]) as [Treatment Since Injury], 
        convert(varchar(max), [How_Many_Years_Worked_Case]) as [How Many Years Worked?],
        convert(varchar(max), [Occupation_Case]) as [Occupation]
    FROM NeedlesSLF.[dbo].case_intake N
JOIN [sma_TRN_Cases] C on C.saga = N.ROW_ID 
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
	[SSI/SSDI], [Date Last Worked], [Doctor Support Claim?], [Status Upon Intake], [Treatment Since Injury], 
	[How Many Years Worked?], [Occupation]
)) AS unpvt;


/* ####################################
2.0 -- Definitions
*/
                
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
---- user_case_data
--SELECT DISTINCT 
--    'C'													as [udfsUDFCtg]
--	,CST.cstnCaseTypeID									as [udfnRelatedPK]
--	,M.field_title										as [udfsUDFName]
--	,'Case'												as [udfsScreenName]
--	,ucf.UDFType										as [udfsType]
--	,ucf.field_len										as [udfsLength]
--	,1													as [udfbIsActive]
--	,'user_case_data' + ucf.column_name					as [udfshortName]
--	,ucf.dropdownValues									as [udfsNewValues]
--	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
--FROM [sma_MST_CaseType] CST
--	JOIN CaseTypeMixture mix
--		ON mix.[SmartAdvocate Case Type] = cst.cstsType
--	JOIN [NeedlesSLF].[dbo].[user_case_matter] M
--		ON M.mattercode = mix.matcode
--		AND M.field_type <> 'label'
--	JOIN	(
--				SELECT DISTINCT	fieldTitle
--				FROM CaseUDF
--			) vd
--		ON vd.FieldTitle = M.field_title
--	JOIN [SANeedlesSLF].[dbo].[NeedlesUserFields] ucf
--		ON ucf.field_num = M.ref_num
--	--LEFT JOIN	(
--	--				SELECT DISTINCT table_Name, column_name
--	--				FROM [NeedlesSLF].[dbo].[document_merge_params]
--	--				WHERE table_Name = 'user_case_data'
--	--			) dmp
--	--	ON dmp.column_name = ucf.field_Title
--	LEFT JOIN [sma_MST_UDFDefinition] def
--		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
--		AND def.[udfsUDFName] = M.field_title
--		AND def.[udfsScreenName] = 'Case'
--		AND def.[udfsType] = ucf.UDFType
--AND def.udfnUDFID IS NULL

--UNION

---- user_case_data
--SELECT DISTINCT 
--    'C'													as [udfsUDFCtg]
--	,CST.cstnCaseTypeID									as [udfnRelatedPK]
--	,M.field_title										as [udfsUDFName]
--	,'Case'												as [udfsScreenName]
--	,ucf.UDFType										as [udfsType]
--	,ucf.field_len										as [udfsLength]
--	,1													as [udfbIsActive]
--	,'user_tab_data' + ucf.column_name					as [udfshortName]
--	,ucf.dropdownValues									as [udfsNewValues]
--	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
--FROM [sma_MST_CaseType] CST
--	JOIN CaseTypeMixture mix
--		ON mix.[SmartAdvocate Case Type] = cst.cstsType
--	JOIN [NeedlesSLF].[dbo].[user_tab_matter] M
--		ON M.mattercode = mix.matcode
--		AND M.field_type <> 'label'
--	JOIN	(
--				SELECT DISTINCT	fieldTitle
--				FROM CaseUDF
--			) vd
--		ON vd.FieldTitle = M.field_title
--	JOIN [SANeedlesSLF].[dbo].[NeedlesUserFields] ucf
--		ON ucf.field_num = M.ref_num
--	LEFT JOIN [sma_MST_UDFDefinition] def
--		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
--		AND def.[udfsUDFName] = M.field_title
--		AND def.[udfsScreenName] = 'Case'
--		AND def.[udfsType] = ucf.UDFType
--	AND def.udfnUDFID IS NULL

--UNION

---- user_party_data
--SELECT DISTINCT 
--    'C'													as [udfsUDFCtg]
--	,CST.cstnCaseTypeID									as [udfnRelatedPK]
--	,M.field_title										as [udfsUDFName]
--	,'Case'												as [udfsScreenName]
--	,ucf.UDFType										as [udfsType]
--	,ucf.field_len										as [udfsLength]
--	,1													as [udfbIsActive]
--	,'user_party_data' + ucf.column_name					as [udfshortName]
--	,ucf.dropdownValues									as [udfsNewValues]
--	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
--FROM [sma_MST_CaseType] CST
--	JOIN CaseTypeMixture mix
--		ON mix.[SmartAdvocate Case Type] = cst.cstsType
--	JOIN [NeedlesSLF].[dbo].[user_party_matter] M
--		ON M.mattercode = mix.matcode
--		AND M.field_type <> 'label'
--	JOIN	(
--				SELECT DISTINCT	fieldTitle
--				FROM CaseUDF
--			) vd
--		ON vd.FieldTitle = M.field_title
--	JOIN [SANeedlesSLF].[dbo].[NeedlesUserFields] ucf
--		ON ucf.field_num = M.ref_num
--	LEFT JOIN [sma_MST_UDFDefinition] def
--		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
--		AND def.[udfsUDFName] = M.field_title
--		AND def.[udfsScreenName] = 'Case'
--		AND def.[udfsType] = ucf.UDFType
--	AND def.udfnUDFID IS NULL

--ORDER BY M.field_title


/* ####################################
3.0 -- Values
*/
     
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
    def.udfnUDFID		as [udvnUDFID],
	'Case'				as [udvsScreenName],
	'C'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM CaseIntakeUDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Case'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO