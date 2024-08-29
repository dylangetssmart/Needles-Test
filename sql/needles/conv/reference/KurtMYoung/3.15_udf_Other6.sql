use SANeedlesKMY
go

/*
Pivot Table
*/
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Other6UDF' AND type = 'U')
BEGIN
    DROP TABLE Other6UDF
END

SELECT casnCaseID, casnOrgCaseTypeID, FieldTitle, FieldVal
INTO Other6UDF
FROM ( 
    SELECT 
        cas.casnCaseID, 
        cas.casnOrgCaseTypeID, 
        CONVERT(VARCHAR(MAX), [City]) AS [City],
        CONVERT(VARCHAR(MAX), [State]) AS [State],
        CONVERT(VARCHAR(MAX), [Alimony]) AS [Alimony],
        CONVERT(VARCHAR(MAX), [Child_Custody]) AS [Child Custody],
        CONVERT(VARCHAR(MAX), [Divorce]) AS [Divorce],
        CONVERT(VARCHAR(MAX), [Property_Settlement]) AS [Property Settlement],
        CONVERT(VARCHAR(MAX), [Separation]) AS [Separation],
        CONVERT(VARCHAR(MAX), [Property_Address]) AS [Property Address],
        CONVERT(VARCHAR(MAX), [Zip]) AS [Zip]
    FROM NeedlesKMY..user_tab6_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [City], [State], [Alimony], [Child Custody], [Divorce], [Property Settlement], [Separation], [Property Address], [Zip]
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
	,'Other6'											as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_tab6_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_tab6_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM Other6UDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN	(
					SELECT DISTINCT table_Name, column_name
					FROM [NeedlesKMY].[dbo].[document_merge_params]
					WHERE table_Name = 'user_tab6_data'
				) dmp
		ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Other6'
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
	'Other6'				as [udvsScreenName],
	'C'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM Other6UDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Other6'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO
