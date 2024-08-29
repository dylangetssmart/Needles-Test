/*
1. Update the pivot table to select the necessary fields
2. Update the UNPIVOT
3. ReplaceFor Other3
4. ReplaceFor tab3
*/

-- use SANeedlesKMY
-- go

/*
Pivot Table
*/
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Other3UDF' AND type = 'U')
BEGIN
    DROP TABLE Other3UDF
END

SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO Other3UDF
FROM ( 
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
		CONVERT(VARCHAR(MAX), [BWC_Form]) AS [BWC Form],
        CONVERT(VARCHAR(MAX), [Value]) AS [Value],
        CONVERT(VARCHAR(MAX), [Type_of_Asset]) AS [Type of Asset],
        CONVERT(VARCHAR(MAX), [Held_By]) AS [Held By]
    FROM NeedlesKMY..user_tab3_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [BWC Form], [Value], [Type of Asset], [Held By]
)) AS unpvt;


----------------------------
--UDF DEFINITION
----------------------------
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
	,'Other3'											as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_tab3_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_tab3_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM Other3UDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN	(
					SELECT DISTINCT table_Name, column_name
					FROM [NeedlesKMY].[dbo].[document_merge_params]
					WHERE table_Name = 'user_tab3_data'
				) dmp
		ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Other3'
		AND def.[udfsType] = ucf.UDFType
AND def.udfnUDFID IS NULL
ORDER BY M.field_title



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
	'Other3'			as [udvsScreenName],
	'C'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM Other3UDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Other3'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO
