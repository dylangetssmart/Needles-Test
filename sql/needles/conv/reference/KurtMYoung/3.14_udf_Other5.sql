use SANeedlesKMY
go

/*
Pivot Table
*/
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Other5UDF' AND type = 'U')
BEGIN
    DROP TABLE Other5UDF
END

SELECT casnCaseID, casnOrgCaseTypeID, FieldTitle, FieldVal
INTO Other5UDF
FROM ( 
    SELECT 
        cas.casnCaseID, 
        cas.casnOrgCaseTypeID, 
        CONVERT(VARCHAR(MAX), [Findings]) AS [Findings],
        CONVERT(VARCHAR(MAX), [IssuesNotes]) AS [IssuesNotes],
        CONVERT(VARCHAR(MAX), [Lung_Cancer]) AS [Lung Cancer],
        CONVERT(VARCHAR(MAX), [Cancer]) AS [Cancer],
        CONVERT(VARCHAR(MAX), [Angina]) AS [Angina],
        CONVERT(VARCHAR(MAX), [Arthritis]) AS [Arthritis],
        CONVERT(VARCHAR(MAX), [Blood_Clots]) AS [Blood Clots],
        CONVERT(VARCHAR(MAX), [Chest_Pains]) AS [Chest Pains],
        CONVERT(VARCHAR(MAX), [Diabetes]) AS [Diabetes],
        CONVERT(VARCHAR(MAX), [Heart_Attack]) AS [Heart Attack],
        CONVERT(VARCHAR(MAX), [Shortness_of_Breath]) AS [Shortness of Breath],
        CONVERT(VARCHAR(MAX), [Stroke]) AS [Stroke],
        CONVERT(VARCHAR(MAX), [Depression]) AS [Depression],
        CONVERT(VARCHAR(MAX), [Pancreatitis]) AS [Pancreatitis],
        CONVERT(VARCHAR(MAX), [Schizophrenia]) AS [Schizophrenia],
        CONVERT(VARCHAR(MAX), [Doctor_Support_Claim]) AS [Doctor Support Claim],
        CONVERT(VARCHAR(MAX), [Body_System]) AS [Body System],
        CONVERT(VARCHAR(MAX), [Doctor_Treating]) AS [Doctor Treating],
        CONVERT(VARCHAR(MAX), [ADHD]) AS [ADHD],
        CONVERT(VARCHAR(MAX), [Asthma]) AS [Asthma],
        CONVERT(VARCHAR(MAX), [Back]) AS [Back],
        CONVERT(VARCHAR(MAX), [Blindness]) AS [Blindness],
        CONVERT(VARCHAR(MAX), [Blood_Disorder]) AS [Blood Disorder],
        CONVERT(VARCHAR(MAX), [Breast_Cancer]) AS [Breast Cancer],
        CONVERT(VARCHAR(MAX), [Bronchitis]) AS [Bronchitis],
        CONVERT(VARCHAR(MAX), [Burns]) AS [Burns],
        CONVERT(VARCHAR(MAX), [Carpal_Tunnel]) AS [Carpal Tunnel],
        CONVERT(VARCHAR(MAX), [Cerebral_Palsy]) AS [Cerebral Palsy],
        CONVERT(VARCHAR(MAX), [Colitis]) AS [Colitis],
        CONVERT(VARCHAR(MAX), [Congestive_Heart_Failure]) AS [Congestive Heart Failure],
        CONVERT(VARCHAR(MAX), [COPD]) AS [COPD],
        CONVERT(VARCHAR(MAX), [Coronary_Artery_Disease]) AS [Coronary Artery Disease],
        CONVERT(VARCHAR(MAX), [Crohns_Disease]) AS [Crohns Disease],
        CONVERT(VARCHAR(MAX), [Cystic_Fibrosis]) AS [Cystic Fibrosis],
        CONVERT(VARCHAR(MAX), [Deafness]) AS [Deafness],
        CONVERT(VARCHAR(MAX), [Eating_Disorders]) AS [Eating Disorders],
        CONVERT(VARCHAR(MAX), [Emphysema]) AS [Emphysema],
        CONVERT(VARCHAR(MAX), [Fibromyalgia]) AS [Fibromyalgia],
        CONVERT(VARCHAR(MAX), [Glaucoma]) AS [Glaucoma],
        CONVERT(VARCHAR(MAX), [HBP]) AS [HBP],
        CONVERT(VARCHAR(MAX), [Headaches]) AS [Headaches],
        CONVERT(VARCHAR(MAX), [Hearing_Loss]) AS [Hearing Loss],
        CONVERT(VARCHAR(MAX), [Heart_Disease]) AS [Heart Disease],
        CONVERT(VARCHAR(MAX), [Hypertension]) AS [Hypertension],
        CONVERT(VARCHAR(MAX), [Irregular_Heartbeat]) AS [Irregular Heartbeat],
        CONVERT(VARCHAR(MAX), [Irritable_Bowel_Syndrome]) AS [Irritable Bowel Syndrome],
        CONVERT(VARCHAR(MAX), [Joint_Replacement]) AS [Joint Replacement],
        CONVERT(VARCHAR(MAX), [Kidney_Disease]) AS [Kidney Disease],
        CONVERT(VARCHAR(MAX), [Leukemia]) AS [Leukemia],
        CONVERT(VARCHAR(MAX), [Liver_Disease]) AS [Liver Disease],
        CONVERT(VARCHAR(MAX), [Lupus]) AS [Lupus],
        CONVERT(VARCHAR(MAX), [Mental_Illness]) AS [Mental Illness],
        CONVERT(VARCHAR(MAX), [Mental_Retardation]) AS [Mental Retardation],
        CONVERT(VARCHAR(MAX), [Multiple_Sclerosis]) AS [Multiple Sclerosis],
        CONVERT(VARCHAR(MAX), [Muscular_Dystrophy]) AS [Muscular Dystrophy],
        CONVERT(VARCHAR(MAX), [Myasthenia_Gravis]) AS [Myasthenia Gravis],
        CONVERT(VARCHAR(MAX), [Neck]) AS [Neck],
        CONVERT(VARCHAR(MAX), [Neuropathy]) AS [Neuropathy],
        CONVERT(VARCHAR(MAX), [Obesity]) AS [Obesity],
        CONVERT(VARCHAR(MAX), [OCD]) AS [OCD],
        CONVERT(VARCHAR(MAX), [Organ_Transplant]) AS [Organ Transplant],
        CONVERT(VARCHAR(MAX), [Other_Heart_Problems]) AS [Other Heart Problems],
        CONVERT(VARCHAR(MAX), [Parkinsons]) AS [Parkinsons],
        CONVERT(VARCHAR(MAX), [PTSD]) AS [PTSD],
        CONVERT(VARCHAR(MAX), [Raynauds_Syndrome]) AS [Raynauds Syndrome],
        CONVERT(VARCHAR(MAX), [Epilepsy]) AS [Epilepsy],
        CONVERT(VARCHAR(MAX), [Spinal_Disorders]) AS [Spinal Disorders],
        CONVERT(VARCHAR(MAX), [VisionBlindness]) AS [VisionBlindness],
        CONVERT(VARCHAR(MAX), [Retinopathy]) AS [Retinopathy],
        CONVERT(VARCHAR(MAX), [Vertigo]) AS [Vertigo],
        CONVERT(VARCHAR(MAX), [Sleep_Apnea]) AS [Sleep Apnea],
        CONVERT(VARCHAR(MAX), [Sleeping_Disorders]) AS [Sleeping Disorders],
        CONVERT(VARCHAR(MAX), [PeripheralArterialDisease]) AS [Peripheral Arterial Disease],
        CONVERT(VARCHAR(MAX), [ALS]) AS [ALS],
        CONVERT(VARCHAR(MAX), [AttentionDeficit_Disorder]) AS [Attention Deficit Disorder],
        CONVERT(VARCHAR(MAX), [Malnutrition]) AS [Malnutrition],
        CONVERT(VARCHAR(MAX), [Ulcers]) AS [Ulcers],
        CONVERT(VARCHAR(MAX), [Skin_Disorder]) AS [Skin Disorder],
        CONVERT(VARCHAR(MAX), [Severe_Weight_Loss]) AS [Severe Weight Loss],
        CONVERT(VARCHAR(MAX), [CFS]) AS [CFS],
        CONVERT(VARCHAR(MAX), [Sjogrens_Syndrome]) AS [Sjogrens Syndrome],
        CONVERT(VARCHAR(MAX), [Sarcoidosis]) AS [Sarcoidosis],
        CONVERT(VARCHAR(MAX), [Sickle_Cell_Anemia]) AS [Sickle Cell Anemia],
        CONVERT(VARCHAR(MAX), [Thyroid]) AS [Thyroid],
        CONVERT(VARCHAR(MAX), [Traumatic_Brain_Injury]) AS [Traumatic Brain Injury],
        CONVERT(VARCHAR(MAX), [Polio]) AS [Polio],
        CONVERT(VARCHAR(MAX), [Substance_Abuse]) AS [Substance Abuse],
        CONVERT(VARCHAR(MAX), [Scoliosis]) AS [Scoliosis],
        CONVERT(VARCHAR(MAX), [Down_Syndrome]) AS [Down Syndrome],
        CONVERT(VARCHAR(MAX), [Fracture_with_Non_Union]) AS [Fracture with Non Union],
        CONVERT(VARCHAR(MAX), [Bipolar_Disorder]) AS [Bipolar Disorder],
        CONVERT(VARCHAR(MAX), [Growth_Impairment]) AS [Growth Impairment],
        CONVERT(VARCHAR(MAX), [Document_Name]) AS [Document Name],
        CONVERT(VARCHAR(MAX), [Note]) AS [Note],
        CONVERT(VARCHAR(MAX), [Location_of_Original]) AS [Location of Original],
        CONVERT(VARCHAR(MAX), [Date_Executed]) AS [Date Executed],
		CONVERT(VARCHAR(MAX), [Ordered_by]) AS [Ordered by],
		CONVERT(VARCHAR(MAX), [Date_Due]) AS [Date Due],
		CONVERT(VARCHAR(MAX), [Date_Done]) AS [Date Done],
		CONVERT(VARCHAR(MAX), [Done_By]) AS [Done By],
		CONVERT(VARCHAR(MAX), [Tickle_Description]) AS [Tickle Description],
		CONVERT(VARCHAR(MAX), [Assigned_To]) AS [Assigned To],
		CONVERT(VARCHAR(MAX), [Name]) AS [Name],
		CONVERT(VARCHAR(MAX), [Type_of_Record]) AS [Type of Record],
		CONVERT(VARCHAR(MAX), [Date_Ordered]) AS [Date Ordered]
    FROM NeedlesKMY..user_tab5_data ud
    JOIN NeedlesKMY..cases_Indexed c ON c.casenum = ud.case_id
    JOIN sma_TRN_Cases cas ON cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)
) pv
UNPIVOT (FieldVal FOR FieldTitle IN (
    [Findings], [IssuesNotes], [Lung Cancer], [Cancer], [Angina], [Arthritis], [Blood Clots], [Chest Pains], [Diabetes], [Heart Attack], 
    [Shortness of Breath], [Stroke], [Depression], [Pancreatitis], [Schizophrenia], [Doctor Support Claim], [Body System], 
    [Doctor Treating], [ADHD], [Asthma], [Back], [Blindness], [Blood Disorder], [Breast Cancer], [Bronchitis], [Burns], [Carpal Tunnel], 
    [Cerebral Palsy], [Colitis], [Congestive Heart Failure], [COPD], [Coronary Artery Disease], [Crohns Disease], [Cystic Fibrosis], 
    [Deafness], [Eating Disorders], [Emphysema], [Fibromyalgia], [Glaucoma], [HBP], [Headaches], [Hearing Loss], [Heart Disease], 
    [Hypertension], [Irregular Heartbeat], [Irritable Bowel Syndrome], [Joint Replacement], [Kidney Disease], [Leukemia], [Liver Disease], 
    [Lupus], [Mental Illness], [Mental Retardation], [Multiple Sclerosis], [Muscular Dystrophy], [Myasthenia Gravis], [Neck], [Neuropathy], 
    [Obesity], [OCD], [Organ Transplant], [Other Heart Problems], [Parkinsons], [PTSD], [Raynauds Syndrome], [Epilepsy], [Spinal Disorders], 
    [VisionBlindness], [Retinopathy], [Vertigo], [Sleep Apnea], [Sleeping Disorders], [Peripheral Arterial Disease], [ALS], 
    [Attention Deficit Disorder], [Malnutrition], [Ulcers], [Skin Disorder], [Severe Weight Loss], [CFS], [Sjogrens Syndrome], 
    [Sarcoidosis], [Sickle Cell Anemia], [Thyroid], [Traumatic Brain Injury], [Polio], [Substance Abuse], [Scoliosis], [Down Syndrome], 
    [Fracture with Non Union], [Bipolar Disorder], [Growth Impairment], [Document Name], [Note], [Location of Original], [Date Executed], [Ordered by],
	[Date Due],[Date Done],[Done By],[Tickle Description],[Assigned To],[Name], [Type of Record],[Date Ordered]
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
	,'Other5'											as [udfsScreenName]
	,ucf.UDFType										as [udfsType]
	,ucf.field_len										as [udfsLength]
	,1													as [udfbIsActive]
	,'user_tab5_data' + ucf.column_name					as [udfshortName]
	,ucf.dropdownValues									as [udfsNewValues]
	,DENSE_RANK() OVER (ORDER BY M.field_title)			as udfnSortOrder
FROM [sma_MST_CaseType] CST
	JOIN CaseTypeMixture mix
		ON mix.[SmartAdvocate Case Type] = cst.cstsType
	JOIN [NeedlesKMY].[dbo].[user_tab5_matter] M
		ON M.mattercode = mix.matcode
		AND M.field_type <> 'label'
	JOIN	(
				SELECT DISTINCT	fieldTitle
				FROM Other5UDF
			) vd
		ON vd.FieldTitle = M.field_title
	JOIN [SANeedlesKMY].[dbo].[NeedlesUserFields] ucf
		ON ucf.field_num = M.ref_num
	LEFT JOIN	(
					SELECT DISTINCT table_Name, column_name
					FROM [NeedlesKMY].[dbo].[document_merge_params]
					WHERE table_Name = 'user_tab5_data'
				) dmp
		ON dmp.column_name = ucf.field_Title
	LEFT JOIN [sma_MST_UDFDefinition] def
		ON def.[udfnRelatedPK] = cst.cstnCaseTypeID
		AND def.[udfsUDFName] = M.field_title
		AND def.[udfsScreenName] = 'Other5'
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
	'Other5'				as [udvsScreenName],
	'C'					as [udvsUDFCtg],
	casnCaseID			as [udvnRelatedID],
	0					as [udvnSubRelatedID],
	udf.FieldVal		as [udvsUDFValue],
	368					as [udvnRecUserID],
	getdate()			as [udvdDtCreated],
	null				as [udvnModifyUserID],
	null				as [udvdDtModified],
	null				as [udvnLevelNo]
FROM Other5UDF udf
	LEFT JOIN sma_MST_UDFDefinition def
	ON def.udfnRelatedPK = udf.casnOrgCaseTypeID
	AND def.udfsUDFName = FieldTitle
	AND def.udfsScreenName = 'Other5'

ALTER TABLE sma_trn_udfvalues ENABLE TRIGGER ALL
GO
