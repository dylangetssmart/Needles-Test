use SANeedlesKMY
go


/*
Pivot Table
*/
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Other2UDF' AND type = 'U')
BEGIN
    DROP TABLE Other2UDF
END

SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO Other2UDF
FROM ( 
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [PPThis_Claim]) as [PP-This Claim],
        convert(varchar(max), [Comp_Type]) as [Comp Type],
        convert(varchar(max), [Amount]) as [Amount],
        convert(varchar(max), [Paid_From]) as [Paid From],
        convert(varchar(max), [Paid_To]) as [Paid To],
        convert(varchar(max), [Date_Awarded]) as [Date Awarded],
        convert(varchar(max), [PPD_rate]) as [PPD rate],
        convert(varchar(max), [Comp_Rate]) as [Comp Rate?],
        convert(varchar(max), [Type_of_Record]) as [Type of Record],
        convert(varchar(max), [Ordered_by]) as [Ordered by],
        convert(varchar(max), [Date_Requested]) as [Date Requested],
        convert(varchar(max), [Provider_Name]) as [Provider Name],
        convert(varchar(max), [No_Records_Exist]) as [No Records Exist]
    FROM NeedlesKMY..user_tab2_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [PP-This Claim], [Comp Type], [Amount], [Paid From], [Paid To], [Date Awarded], [PPD rate], [Comp Rate?], [Type of Record], 
    [Ordered by], [Date Requested], [Provider Name], [No Records Exist]
)) AS unpvt;


----------------------------
--UDF DEFINITION
----------------------------
alter table [sma_MST_UDFDefinition] disable trigger all
GO

-- ds 07-10-2024 // update udfsNewValues max length to support data
alter table sma_mst_udfdefinition  
alter column udfsNewValues varchar(2500)  
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
	,'Other2'											as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_tab2_' + ucf.column_name						as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_tab2_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM Other2UDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN	(
					SELECT DISTINCT table_Name, column_name
					FROM [NeedlesKMY].[dbo].[document_merge_params]
					WHERE table_Name = 'user_tab2_data'
				) dmp
		ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Other2'
		AND def.[udfsType] = ucf.UDFType
-- WHERE M.Field_Title <> 'Location'
AND def.udfnUDFID IS NULL
--AND mix.matcode IN ('MVA','PRE')
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
	'Other2'				as [udvsScreenName],
	'C'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM Other2UDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Other2'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO
