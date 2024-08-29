-- USE SANeedlesSLF
GO
/*
alter table [dbo].[sma_TRN_Employment] disable trigger all
delete from [dbo].[sma_TRN_Employment] 
DBCC CHECKIDENT ('[dbo].[sma_TRN_Employment]', RESEED, 0);
alter table [dbo].[sma_TRN_Employment] enable trigger all
*/

--sp_help [sma_TRN_Employment]

ALTER TABLE sma_TRN_Employment
	ALTER COLUMN [empsJobTitle] varchar(500)
GO  

INSERT INTO [dbo].[sma_TRN_Employment]
           ([empnPlaintiffID]
           ,[empnEmprAddressID]
           ,[empnEmployerID]
           ,[empnContactPersonID]
           ,[empnCPAddressId]
           ,[empsJobTitle]
           ,[empnSalaryFreqID]
           ,[empnSalaryAmt]
           ,[empnCommissionFreqID]
           ,[empnCommissionAmt]
           ,[empnBonusFreqID]
           ,[empnBonusAmt]
           ,[empnOverTimeFreqID]
           ,[empnOverTimeAmt]
           ,[empnOtherFreqID]
           ,[empnOtherCompensationAmt]
           ,[empsComments]
           ,[empbWorksOffBooks]
           ,[empsCompensationComments]
           ,[empbWorksPartiallyOffBooks]
           ,[empbOnTheJob]
           ,[empbWCClaim]
           ,[empbContinuing]
           ,[empdDateHired]
           ,[empnUDF1]
           ,[empnUDF2]
           ,[empnRecUserID]
           ,[empdDtCreated]
           ,[empnModifyUserID]
           ,[empdDtModified]
           ,[empnLevelNo]
           ,[empnauthtodefcoun]
           ,[empnauthtodefcounDt]
           ,[empnTotalDisability]
           ,[empnAverageWeeklyWage]
           ,[empnEmpUnion]
           ,[NotEmploymentReasonID]
           ,[empdDateTo]
           ,[empsDepartment]
           ,[empdSent]
           ,[empdReceived]
           ,[empnStatusId]
           ,[empnWorkSiteId])
SELECT
	(
		select plnnPlaintiffID
		from sma_trn_plaintiff
		where plnnCaseID = cas.casncaseid and plnbIsPrimary = 1
	)						as [empnPlaintiffID]		--Plaintiff ID
	,ioco.AID				as [empnEmprAddressID]		--employer org AID
	,ioco.CID				as [empnEmployerID]			--employer org CID
	,ioci.CID				as [empnContactPersonID]	--employer indv CID
	,ioci.AID				as [empnCPAddressId]		--employer indv AID
    ,ci.Occupation_Case		as [empsJobTitle]			--ds 6/6/2024 - Job Title
    ,null					as [empnSalaryFreqID]		--ds 6/6/2024 - Salary Frequency -> sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnSalaryAmt]			--ds 6/6/2024 - Salary Amount
    ,null					as [empnCommissionFreqID]	--Commission: (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnCommissionAmt]		--Commission Amount
	,null					as [empnBonusFreqID]		--Bonus: (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null					as [empnBonusAmt]			--Bonus Amount
	,null					as [empnOverTimeFreqID]		--Overtime (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null					as [empnOverTimeAmt]		--Overtime Amoun
	,null					as [empnOtherFreqID]		--Other Compensation (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnOtherCompensationAmt]	--Other Compensation Amount
	,NULL					as [empsComments]			 -- ds 6/6/2024 - Employer Comments
	,null					as [empbWorksOffBooks]			--bit
	,null					as empsCompensationComments			-- ds 6/6/2024 - Compensation Comments
	,null					as [empbWorksPartiallyOffBooks]	--bit
	,null					as [empbOnTheJob]				--On the job injury? bit
	,null					as [empbWCClaim]				--W/C Claim?  bit
	,null					as [empbContinuing]			--continuing?  bit
	,NULL					as [empdDateHired]				-- ds 6/6/2024 - Date From
	,null					as [empnUDF1]
	,null					as [empnUDF2]
	,368					as [empnRecUserID]
	,getdate()				as [empdDtCreated]
	,null					as [empnModifyUserID]
	,null					as [empdDtModified]
	,null					as [empnLevelNo]
	,null					as [empnauthtodefcoun]		--Auth. to defense cousel:  bit
	,null					as [empnauthtodefcounDt]	--Auth. to defense cousel:  date
	,null					as [empnTotalDisability]	--Temporary Total Disability (TTD)
	,null					as [empnAverageWeeklyWage]		--Average weekly wage (AWW)
	,null					as [empnEmpUnion]			--Unique Contact ID of Union
	,null					as [NotEmploymentReasonID]		--1=Minor; 2=Retired; 3=Unemployed; (MST?)
	,null					as [empdDateTo]			--ds 6/6/2024 - Date To
	,null					as [empsDepartment]		--Department
	,null					as [empdSent]			--emp verification request sent
	,null					as [empdReceived]		--emp verification request received
	,null					as [empnStatusId]		--status  sma_MST_EmploymentStatuses.ID
	,null					as [empnWorkSiteId]
FROM NeedlesSLF..case_intake ci
	-- Link to SA Contact Card via:
		-- case_intake -> case_intake_name -> names -> IndvOrgContacts_Indexed
	left join NeedlesSLF..case_intake_name cin
		on cin.field_title = 'employer_case'
		and cin.intake_taken = ci.intake_taken
	join NeedlesSLF.dbo.names n
		on cin.user_name = n.names_id
	-- Indv
	left join SANeedlesSLF.dbo.IndvOrgContacts_Indexed ioci
		on n.names_id = ioci.saga
		and ioci.CTG = 1
	-- Org
	left join SANeedlesSLF.dbo.IndvOrgContacts_Indexed ioco
		on n.names_id = ioco.saga
		and ioco.CTG = 2
	
	JOIN [sma_TRN_cases] CAS
		on CAS.saga = ci.row_id

where isnull(employer_case,'') <> ''
GO

--------------------------------------------------------------------------------------
-- Employment records for Employer_Name_Case

INSERT INTO [dbo].[sma_TRN_Employment]
           ([empnPlaintiffID]
           ,[empnEmprAddressID]
           ,[empnEmployerID]
           ,[empnContactPersonID]
           ,[empnCPAddressId]
           ,[empsJobTitle]
           ,[empnSalaryFreqID]
           ,[empnSalaryAmt]
           ,[empnCommissionFreqID]
           ,[empnCommissionAmt]
           ,[empnBonusFreqID]
           ,[empnBonusAmt]
           ,[empnOverTimeFreqID]
           ,[empnOverTimeAmt]
           ,[empnOtherFreqID]
           ,[empnOtherCompensationAmt]
           ,[empsComments]
           ,[empbWorksOffBooks]
           ,[empsCompensationComments]
           ,[empbWorksPartiallyOffBooks]
           ,[empbOnTheJob]
           ,[empbWCClaim]
           ,[empbContinuing]
           ,[empdDateHired]
           ,[empnUDF1]
           ,[empnUDF2]
           ,[empnRecUserID]
           ,[empdDtCreated]
           ,[empnModifyUserID]
           ,[empdDtModified]
           ,[empnLevelNo]
           ,[empnauthtodefcoun]
           ,[empnauthtodefcounDt]
           ,[empnTotalDisability]
           ,[empnAverageWeeklyWage]
           ,[empnEmpUnion]
           ,[NotEmploymentReasonID]
           ,[empdDateTo]
           ,[empsDepartment]
           ,[empdSent]
           ,[empdReceived]
           ,[empnStatusId]
           ,[empnWorkSiteId])
SELECT
	(
		select plnnPlaintiffID
		from sma_trn_plaintiff
		where plnnCaseID = cas.casncaseid and plnbIsPrimary = 1
	)						as [empnPlaintiffID]		--Plaintiff ID
	,(
		SELECT addnAddressID
		from sma_MST_Address
		where addnContactID = org.connContactID
		and addnContactCtgID = 2
	)						as [empnEmprAddressID]		--employer org AID
	,org.connContactID		as [empnEmployerID]			--employer org CID
	,null					as [empnContactPersonID]	--employer indv CID
	,null					as [empnCPAddressId]		--employer indv AID
    ,ci.Occupation_Case		as [empsJobTitle]			--ds 6/6/2024 - Job Title
    ,null					as [empnSalaryFreqID]		--ds 6/6/2024 - Salary Frequency -> sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnSalaryAmt]			--ds 6/6/2024 - Salary Amount
    ,null					as [empnCommissionFreqID]	--Commission: (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnCommissionAmt]		--Commission Amount
	,null					as [empnBonusFreqID]		--Bonus: (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null					as [empnBonusAmt]			--Bonus Amount
	,null					as [empnOverTimeFreqID]		--Overtime (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null					as [empnOverTimeAmt]		--Overtime Amoun
	,null					as [empnOtherFreqID]		--Other Compensation (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null					as [empnOtherCompensationAmt]	--Other Compensation Amount
	,NULL					as [empsComments]			 -- ds 6/6/2024 - Employer Comments
	,null					as [empbWorksOffBooks]			--bit
	,null					as empsCompensationComments			-- ds 6/6/2024 - Compensation Comments
	,null					as [empbWorksPartiallyOffBooks]	--bit
	,null					as [empbOnTheJob]				--On the job injury? bit
	,null					as [empbWCClaim]				--W/C Claim?  bit
	,null					as [empbContinuing]			--continuing?  bit
	,NULL					as [empdDateHired]				-- ds 6/6/2024 - Date From
	,null					as [empnUDF1]
	,null					as [empnUDF2]
	,368					as [empnRecUserID]
	,getdate()				as [empdDtCreated]
	,null					as [empnModifyUserID]
	,null					as [empdDtModified]
	,null					as [empnLevelNo]
	,null					as [empnauthtodefcoun]		--Auth. to defense cousel:  bit
	,null					as [empnauthtodefcounDt]	--Auth. to defense cousel:  date
	,null					as [empnTotalDisability]	--Temporary Total Disability (TTD)
	,null					as [empnAverageWeeklyWage]		--Average weekly wage (AWW)
	,null					as [empnEmpUnion]			--Unique Contact ID of Union
	,null					as [NotEmploymentReasonID]		--1=Minor; 2=Retired; 3=Unemployed; (MST?)
	,null					as [empdDateTo]			--ds 6/6/2024 - Date To
	,null					as [empsDepartment]		--Department
	,null					as [empdSent]			--emp verification request sent
	,null					as [empdReceived]		--emp verification request received
	,null					as [empnStatusId]		--status  sma_MST_EmploymentStatuses.ID
	,null					as [empnWorkSiteId]
FROM NeedlesSLF..case_intake ci
	left join SANeedlesSLF..sma_mst_OrgContacts org
		on org.saga = ci.row_id
		and org.saga_ref = 'employer'
	JOIN [sma_TRN_cases] CAS
		on CAS.saga = ci.row_id
where isnull(employer_name_case,'') <> ''
GO


