-- USE SANeedlesSLF
go

--Plaintiffs
/*
select name_id, first_name, last_name, name_id_2, First_Name_Party_2, Last_Name_Party_2
From NeedlesSLF..case_intake
where isnull(name_id,0)<>0
*/

--INSERT (P)-PLAINTIFF FOR CASE TYPES
INSERT INTO sma_MST_SubRole
(
	sbrnRoleID
	,sbrsDscrptn
	,sbrnCaseTypeID
	,sbrnTypeCode
)
SELECT
	4
	,'(P)-Plaintiff'
	,cst.cstnCaseTypeID
	,(
		select srcnCodeId
		from sma_MST_SubRoleCode 
		where srcsDscrptn = '(P)-Plaintiff' and srcnRoleID = 4
	)
FROM sma_MST_CaseType cst
	JOIN sma_trn_cases cas
		on cas.casnOrgCaseTypeID = cst.cstnCaseTypeID
WHERE cas.cassCaseNumber like 'Intake%'
EXCEPT
SELECT
	sbrnRoleID
	,sbrsDscrptn
	,sbrnCaseTypeID
	,sbrnTypeCode 
FROM sma_MST_SubRole


-----------------------
--INSERT PLAINTIFF
-----------------------
INSERT INTO [sma_TRN_Plaintiff]
(
 [plnnCaseID],[plnnContactCtg],[plnnContactID],[plnnAddressID],[plnnRole],[plnbIsPrimary],[plnbWCOut],[plnnPartiallySettled],[plnbSettled],[plnbOut],
 [plnbSubOut],[plnnSeatBeltUsed],[plnnCaseValueID],[plnnCaseValueFrom],[plnnCaseValueTo],[plnnPriority],[plnnDisbursmentWt],[plnbDocAttached],[plndFromDt],
 [plndToDt],[plnnRecUserID],[plndDtCreated],[plnnModifyUserID],[plndDtModified],[plnnLevelNo],[plnsMarked],[saga],[plnnNoInj],[plnnMissing],
 [plnnLIPBatchNo],[plnnPlaintiffRole],[plnnPlaintiffGroup],[plnnPrimaryContact],[saga_party]
)
SELECT DISTINCT
	CAS.casnCaseID				as [plnnCaseID]
	,CIO.CTG					as [plnnContactCtg]
	,CIO.CID					as [plnnContactID]
	,CIO.AID					as [plnnAddressID]
	,(
		Select top 1 sbrnSubRoleId
		from [sma_MST_SubRole]
		where sbrnCaseTypeID = CAS.casnOrgCaseTypeID and sbrnRoleID = 4 and sbrsDscrptn = '(P)-Plaintiff'
	)							as [plnnRole]
	,1							as [plnbIsPrimary]
	,0,0,0,0,0,0,null,null,null,null,null,null,GETDATE(),null,
	368						as [plnnRecUserID],
	GETDATE()					as [plndDtCreated],
	null,null,
	null						as [plnnLevelNo],  
	null,'',null,null,null,null,null,
	1						as [plnnPrimaryContact],
	null					as [saga_party]
--select *
FROM NeedlesSLF..case_intake c
	JOIN [sma_TRN_Cases] CAS
		on CAS.saga = c.ROW_ID 
	JOIN IndvOrgContacts_Indexed CIO
		on CIO.SAGA = c.name_id
WHERE isnull(name_id,0)<>0
	and cas.cassCaseNumber like 'Intake%'



