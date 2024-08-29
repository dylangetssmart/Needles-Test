use SANeedlesKMY

/* ####################################
1.0 -- Prior/Subsequent Injuries
*/

ALTER TABLE sma_TRN_PriorInjuries DISABLE TRIGGER ALL
GO

INSERT INTO sma_TRN_PriorInjuries
(
	[prlnInjuryID]
	,[prldPrAccidentDt]
	,[prldDiagnosis]
	,[prlsDescription]
	,[prlsComments]
	,[prlnPlaintiffID]
	,[prlnCaseID]
	,[prlnInjuryType]
	,[prlnParentInjuryID]
	,[prlsInjuryDesc]
	,[prlnRecUserID]
	,[prldDtCreated]
	,[prlnModifyUserID]
	,[prldDtModified]
	,[prlnLevelNo]
	,[prlbCaseRelated]
	,[prlbFirmCase]
	,[prlsPrCaseNo]
	,[prlsInjury]
)
SELECT
	null											as [prlnInjuryID]
	,null											as [prldPrAccidentDt]
	,null											as [prldDiagnosis]
	,null											as [prlsDescription]
	,null											as [prlsComments]
	,pln.plnnContactID								as [prlnPlaintiffID]
	,cas.casnCaseID									as [prlnCaseID]
	,3												as [prlnInjuryType]
	,null											as [prlnParentInjuryID]
	,null											as [prlsInjuryDesc]
	,368											as [prlnRecUserID]
	,getdate()										as [prldDtCreated]
	,null											as [prlnModifyUserID]
	,null											as [prldDtModified]
	,1												as [prlnLevelNo]
	,0												as [prlbCaseRelated]
	,0												as [prlbFirmCase]
	,null											as [prlsPrCaseNo]
	,'Prior Injuries:' + ud.prior_injuries			as [prlsInjury]
from NeedlesKMY..user_party_data ud
	join sma_TRN_Cases cas
		on cas.cassCaseNumber = ud.case_id
	join sma_TRN_Plaintiff pln
		on pln.plnnCaseID = cas.casnCaseID
where isnull(ud.Prior_Injuries,'') <> ''

ALTER TABLE sma_TRN_PriorInjuries Enable TRIGGER ALL
GO