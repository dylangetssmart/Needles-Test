USE SANeedlesKMY
GO

ALTER TABLE sma_trn_Casevalue DISABLE TRIGGER ALL
GO

INSERT INTO sma_trn_Casevalue
(
	csvncaseid
	,csvnValueID
	,csvnValue
	,csvsComments
	,csvdFromDate
	,csvdToDate
	,csvnRecUserID
	,csvdDtCreated
	,csvnMinSettlementValue
	,csvnExpectedResolutionDate
	,csvnMaxSettlementValue
)
SELECT DISTINCT
	cas.casncaseid			as csvncaseid,
	NULL					as csvnValueID,
	NULL					as csvnValue,
	''						as csvsComments, 
	getdate()				as  csvdFromDate,
	null					as csvdToDate,
	368						as csvnRecUserID,
	getdate()				as csvdDtCreated,
	minimum_amount			as csvnMinSettlementValue,
	null					as csvnExpectedResolutionDate,
	null					as csvnMaxSettlementValue
FROM NeedlesKMY..insurance_Indexed ii
JOIN sma_trn_Cases cas
	on cas.cassCaseNumber = convert(varchar,ii.case_num)
WHERE isnull(minimum_amount,0) <> 0

ALTER TABLE sma_trn_Casevalue ENABLE TRIGGER ALL