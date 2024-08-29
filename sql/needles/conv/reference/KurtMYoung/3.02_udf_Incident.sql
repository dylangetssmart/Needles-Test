use SANeedlesKMY
go


/*
Pivot Table
*/
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'IncidentUDF' AND type = 'U')
BEGIN
    DROP TABLE IncidentUDF
END

SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO IncidentUDF
FROM (
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [Location]) as [Location],
        convert(varchar(max), [City]) as [City]
    FROM NeedlesKMY..user_case_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.casenum
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.casenum)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [Location], [City]
)) AS unpvt



----------------------------
--UDF DEFINITION
----------------------------
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
    'I'											as [udfsUDFCtg]
	,cg.IncidentTypeID							as [udfnRelatedPK]
    ,M.field_title								as [udfsUDFName] 
    ,'Incident Wizard'							as [udfsScreenName]
    ,ucf.UDFType								as [udfsType]
    ,ucf.field_len								as [udfsLength]
    ,1											as [udfbIsActive]
	,'user_Case_Data' + ucf.column_name			as [udfshortName]
    ,ucf.dropdownValues							as [udfsNewValues]
    ,DENSE_RANK() over( order by M.field_title)	as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		on mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN NeedlesKMY.[dbo].[user_case_matter] M
		on M.mattercode=mix.matcode and M.field_type <> 'label'
	JOIN (
			select DISTINCT fieldTitle
			from IncidentUDF
		) vd 
		on vd.FieldTitle = m.field_title
	JOIN NeedlesUserFields ucf
		on ucf.field_num = m.ref_num
	LEFT JOIN [sma_MST_UDFDefinition] def
		on def.[udfnRelatedPK] = cst.cstnCaseTypeID
		and def.[udfsUDFName] = m.field_title
		and def.[udfsScreenName] = 'Incident Wizard'
		and udfstype = ucf.UDFType
	join sma_MST_CaseGroup cg
		on cgpnCaseGroupID = cst.cstnGroupID
where def.udfnUDFID IS NULL
order by m.field_title



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
	'Incident Wizard'	as [udvsScreenName],
	'I'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM IncidentUDF udf
	-- Link to CaseType to get CaseGroupID
	join sma_MST_CaseType ct
		on ct.cstnCaseTypeID = udf.casnOrgCaseTypeID
	-- Link to CaseGroup to get IncidentTypeID
	join sma_MST_CaseGroup cg
		on cg.cgpnCaseGroupID = ct.cstnGroupID
	left JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = cg.IncidentTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Incident Wizard'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO
