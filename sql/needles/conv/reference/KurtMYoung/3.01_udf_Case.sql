use SANeedlesKMY
go

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CaseUDF' AND type = 'U')
BEGIN
    DROP TABLE CaseUDF
END

/* ####################################
1.0 - Build CaseUDF from user_case_data
*/

SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
INTO CaseUDF
FROM ( 
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
		convert(varchar(max), [Allowance]) as [Allowance], 
        convert(varchar(max), [AWW]) as [AWW], 
        convert(varchar(max), [FWW]) as [FWW], 
        convert(varchar(max), [Treatment_History]) as [Treatment History], 
        convert(varchar(max), [Incident_Rpt_Date]) as [Incident Rpt Date], 
        convert(varchar(max), [Place_of_Assignment]) as [Place of Assignment], 
        convert(varchar(max), [If_yes_to_whom]) as [If yes, to whom?], 
        convert(varchar(max), [VSSR]) as [VSSR], 
        convert(varchar(max), [Third_Party]) as [Third Party], 
        convert(varchar(max), [PPThis_Claim]) as [PP-This Claim], 
        convert(varchar(max), [TT_Days]) as [TT Days], 
        convert(varchar(max), [TT_Dollars]) as [TT Dollars], 
        convert(varchar(max), [Fee_Arrangement]) as [Fee Arrangement], 
        convert(varchar(max), [Appt_Made]) as [Appt Made?], 
        convert(varchar(max), [SSISSDI]) as [SSI/SSDI], 
        convert(varchar(max), [Date_Last_Worked]) as [Date Last Worked], 
        convert(varchar(max), [Doctor_Support_Claim]) as [Doctor Support Claim?], 
        -- convert(varchar(max), [Date_Application_Denied]) as [Date Application Denied],  --ds 07/11/2024 // moved to 2.15_CriticalDeadlines
        convert(varchar(max), [Status_Upon_Intake]) as [Status Upon Intake], 
        convert(varchar(max), [Treatment_Since_Injury]) as [Treatment Since Injury], 
        convert(varchar(max), [Occupation]) as [Occupation], 
        convert(varchar(max), [How_Many_Years_Worked]) as [How Many Years Worked?]
    FROM NeedlesKMY..user_case_data ud
    --JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.casenum
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.casenum)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
	[Allowance], [AWW], [FWW], [Treatment History], [Incident Rpt Date], [Place of Assignment], [If yes, to whom?], 
    [VSSR], [Third Party], [PP-This Claim], [TT Days], [TT Dollars], [Fee Arrangement], [Appt Made?], [SSI/SSDI], 
    [Date Last Worked], [Doctor Support Claim?], [Status Upon Intake], [Treatment Since Injury], 
    [Occupation], [How Many Years Worked?]
)) AS unpvt;


--/* ####################################
--1.1 - Insert into CaseUDF from user_party_data
--*/
                
INSERT INTO CaseUDF (casncaseid, casnorgcasetypeID, fieldTitle, FieldVal)
SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
FROM ( 
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [Employer_Type]) as [Employer Type], 
        convert(varchar(max), [Rep]) as [Rep], 
        convert(varchar(max), [Managed_Care]) as [Managed Care], 
        convert(varchar(max), [Risk]) as [Risk], 
        convert(varchar(max), [PP_Total]) as [PP Total], 
        convert(varchar(max), [Marital_Status]) as [Marital Status], 
        convert(varchar(max), [Dependents]) as [Dependents], 
        convert(varchar(max), [Child_Support]) as [Child Support], 
        convert(varchar(max), [Prior_Accidents]) as [Prior Accidents], 
        convert(varchar(max), [Union]) as [Union], 
        convert(varchar(max), [Receiving_Disability]) as [Receiving Disability], 
        convert(varchar(max), [Type_of_Disability]) as [Type of Disability], 
        convert(varchar(max), [Technical_Training]) as [Technical Training], 
        convert(varchar(max), [Alt_Contact_Phone]) as [Alt Contact Phone], 
        convert(varchar(max), [Handedness]) as [Handedness], 
        convert(varchar(max), [File_ID]) as [File ID], 
        convert(varchar(max), [CommentsConversion]) as [Comments-Conversion], 
        convert(varchar(max), [File_Loc]) as [File Loc], 
        convert(varchar(max), [How_Many]) as [How Many], 
        convert(varchar(max), [Dependants]) as [Dependants], 
        convert(varchar(max), [Age]) as [Age], 
        convert(varchar(max), [Caller]) as [Caller], 
        convert(varchar(max), [Spouses_SS#]) as [Spouse's SS#], 
        convert(varchar(max), [Valid_DL]) as [Valid D.L.], 
        convert(varchar(max), [Caller_Cell_Phone]) as [Caller Cell Phone], 
        convert(varchar(max), [Caller_Home_Phone]) as [Caller Home Phone], 
        convert(varchar(max), [Spouse_Deceased]) as [Spouse Deceased], 
        convert(varchar(max), [Divorce_Decree_Provided]) as [Divorce Decree Provided], 
        convert(varchar(max), [Are_You_a_US_Citizen]) as [Are You a US Citizen?], 
        convert(varchar(max), [Specific_Bequest]) as [Specific Bequest], 
        convert(varchar(max), [Employment]) as [Employment]
    FROM NeedlesKMY..user_party_data ud
    --JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
	[Employer Type], [Rep], [Managed Care], [Risk], [PP Total], [Marital Status], 
    [Dependents], [Child Support], [Prior Accidents], [Union], [Receiving Disability], [Type of Disability], [Technical Training], 
    [Alt Contact Phone], [Handedness], [File ID], [Comments-Conversion], [File Loc], [How Many], [Dependants], [Age], 
    [Caller], [Spouse's SS#], [Valid D.L.], [Caller Cell Phone], [Caller Home Phone], [Spouse Deceased], [Divorce Decree Provided], 
    [Are You a US Citizen?], [Specific Bequest], [Employment]
)) AS unpvt;



--/* ####################################
--1.2 - Insert into CaseUDF from user_tab_data
--*/

INSERT INTO CaseUDF (casncaseid, casnorgcasetypeID, fieldTitle, FieldVal)
SELECT casncaseid, casnorgcasetypeID, fieldTitle, FieldVal
FROM ( 
    SELECT cas.casnCaseID, cas.CasnOrgCaseTypeID, 
        convert(varchar(max), [Start_Date]) as [Start Date], 
        convert(varchar(max), [End_Date]) as [End Date], 
        convert(varchar(max), [Job_Title]) as [Job Title], 
        convert(varchar(max), [Reason_for_leaving]) as [Reason for leaving], 
        convert(varchar(max), [Rate_of_Pay]) as [Rate of Pay], 
        convert(varchar(max), [FPT_Employment]) as [F/PT Employment?], 
        convert(varchar(max), [Hours_Worked_per_week]) as [Hours Worked per week], 
        convert(varchar(max), [Current_Medication]) as [Current Medication]
    FROM NeedlesKMY..user_tab_data ud
    --JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
	[Start Date], [End Date], [Job Title], [Reason for leaving], 
    [Rate of Pay], [F/PT Employment?], [Hours Worked per week], [Current Medication]
)) AS unpvt;



/* ####################################
2.0 -- Definitions
*/
                
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
-- user_case_data
SELECT DISTINCT 
    'C'													as [udfsUDFCtg]
	,CST.cstnCaseTypeID									as [udfnRelatedPK]
	,M.field_title										as [udfsUDFName]
	,'Case'												as [udfsScreenName]
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
				FROM CaseUDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	--LEFT JOIN	(
	--				SELECT DISTINCT table_Name, column_name
	--				FROM [NeedlesKMY].[dbo].[document_merge_params]
	--				WHERE table_Name = 'user_case_data'
	--			) dmp
	--	ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Case'
		AND def.[udfsType] = ucf.UDFType
AND def.udfnUDFID IS NULL

UNION

-- user_case_data
SELECT DISTINCT 
    'C'													as [udfsUDFCtg]
	,CST.cstnCaseTypeID									as [udfnRelatedPK]
	,M.field_title										as [udfsUDFName]
	,'Case'												as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_tab_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_tab_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM CaseUDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Case'
		AND def.[udfsType] = ucf.UDFType
	AND def.udfnUDFID IS NULL

UNION

-- user_party_data
SELECT DISTINCT 
    'C'													as [udfsUDFCtg]
	,CST.cstnCaseTypeID									as [udfnRelatedPK]
	,M.field_title										as [udfsUDFName]
	,'Case'												as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_party_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_party_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM CaseUDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Case'
		AND def.[udfsType] = ucf.UDFType
	AND def.udfnUDFID IS NULL

ORDER BY M.field_title


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
FROM CaseUDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Case'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO