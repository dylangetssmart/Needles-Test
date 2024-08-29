USE [SANeedlesKMY]
GO

/*
alter table [sma_TRN_InsuranceCoverage] disable trigger all
delete from [sma_TRN_InsuranceCoverage]
DBCC CHECKIDENT ('[sma_TRN_InsuranceCoverage]', RESEED, 0);
alter table [sma_TRN_InsuranceCoverage] disable trigger all
*/




IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_InsuranceCoverage'))
BEGIN
    ALTER TABLE [sma_TRN_InsuranceCoverage] 
	ADD [saga] int NULL; 
END


/*
-------------------------------------------------------------------------------
##############################################################################
-------------------------------------------------------------------------------
Build support table with anchors and values
*/
IF EXISTS (select * from sys.objects where name='Insurance_Contacts_Helper' and type='U')
BEGIN
    DROP TABLE Insurance_Contacts_Helper
END
GO

CREATE TABLE Insurance_Contacts_Helper
(
    tableIndex				int IDENTITY(1,1) NOT NULL,
    insurance_id			int,		-- table id
    insurer_id				int,			-- insurance company
    adjuster_id				int,		-- adjuster
    insured					varchar(100),	-- a person or organization covered by insurance
    incnInsContactID		int, 
    incnInsAddressID		int,
    incnAdjContactId		int,
    incnAdjAddressID		int,
    incnInsured				int,
	pord					varchar(1),
	caseID					int,
	PlaintiffDefendantID	int
 CONSTRAINT IX_Insurance_Contacts_Helper PRIMARY KEY CLUSTERED 
(
	tableIndex
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_insurance_id ON Insurance_Contacts_Helper (insurance_id);   
GO
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_insurer_id ON Insurance_Contacts_Helper (insurer_id);   
GO
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_adjuster_id ON Insurance_Contacts_Helper (adjuster_id); 
GO  

---(0)---
INSERT INTO Insurance_Contacts_Helper
(
    insurance_id,
    insurer_id,
    adjuster_id,
    insured,
    incnInsContactID,
    incnInsAddressID,
    incnAdjContactId,
    incnAdjAddressID,
    incnInsured,
	pord,
	caseID,
	PlaintiffDefendantID
) 
SELECT 
    INS.insurance_id,
    INS.insurer_id,
    INS.adjuster_id,
    INS.insured,
    IOC1.CID				as incnInsContactID, 
    IOC1.AID				as incnInsAddressID,
    IOC2.CID				as incnAdjContactId,
    IOC2.AID				as incnAdjAddressID,
    INFO.UniqueContactId	as incnInsured,
    null					as pord,
    CAS.casnCaseID			as caseID,
	null					as PlaintiffDefendantID
FROM NeedlesKMY.[dbo].[insurance_Indexed] INS
JOIN [sma_TRN_Cases] CAS on CAS.cassCaseNumber=INS.case_num
JOIN IndvOrgContacts_Indexed IOC1 on IOC1.saga=INS.insurer_id and isnull(INS.insurer_id,0)<>0
LEFT JOIN IndvOrgContacts_Indexed IOC2 on IOC2.saga=INS.adjuster_id and isnull(INS.adjuster_id,0)<>0
JOIN [sma_MST_IndvContacts] I on I.cinsLastName=INS.insured and I.cinsGrade=INS.insured and I.saga=-1
JOIN [sma_MST_AllContactInfo] INFO on INFO.ContactId=I.cinnContactID and INFO.ContactCtg=I.cinnContactCtg 
GO

DBCC DBREINDEX('Insurance_Contacts_Helper',' ',90) WITH NO_INFOMSGS 
GO

---(0)--- (prepare for multiple party)
IF EXISTS (select * from sys.objects where Name='multi_party_helper_temp')
BEGIN
    DROP TABLE [multi_party_helper_temp]
END
GO

SELECT INS.insurance_id	as ins_id, T.plnnPlaintiffID
INTO [multi_party_helper_temp]
FROM NeedlesKMY.[dbo].[insurance_Indexed] INS
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = INS.case_num
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA = INS.party_id
JOIN [sma_TRN_Plaintiff] T on T.plnnContactID=IOC.CID and T.plnnContactCtg=IOC.CTG and T.plnnCaseID=CAS.casnCaseID
GO

UPDATE [Insurance_Contacts_Helper] 
SET pord='P', PlaintiffDefendantID=A.plnnPlaintiffID
FROM [multi_party_helper_temp] A
WHERE A.ins_id = insurance_id
GO

IF EXISTS (select * from sys.objects where Name='multi_party_helper_temp')
BEGIN
    DROP TABLE [multi_party_helper_temp]
END
GO

SELECT 
    INS.insurance_id	as ins_id,	
    D.defnDefendentID
INTO [multi_party_helper_temp]
FROM NeedlesKMY.[dbo].[insurance_Indexed] INS
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = INS.case_num
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA = INS.party_id
JOIN [sma_TRN_Defendants] D on D.defnContactID=IOC.CID and D.defnContactCtgID=IOC.CTG and D.defnCaseID=CAS.casnCaseID
GO

UPDATE [Insurance_Contacts_Helper] 
SET pord='D', PlaintiffDefendantID=A.defnDefendentID
FROM [multi_party_helper_temp] A
WHERE A.ins_id = insurance_id
GO

-------------------------------------------------------------------------------
-- Insurance Types ############################################################
-------------------------------------------------------------------------------
INSERT INTO [sma_MST_InsuranceType] (intsDscrptn ) 
SELECT 'Unspecified'
UNION
SELECT DISTINCT policy_type FROM NeedlesKMY.[dbo].[insurance] INS WHERE isnull(policy_type,'') <> '' 
EXCEPT
SELECT intsDscrptn FROM [sma_MST_InsuranceType]
GO

---
ALTER TABLE [sma_TRN_InsuranceCoverage] DISABLE TRIGGER ALL
---
GO

---(1)--- Insurance of plaintiffs
--INSERT INTO [sma_TRN_InsuranceCoverage] 
--(
--	[incnCaseID],[incnInsContactID],[incnInsAddressID],[incbCarrierHasLienYN],[incnInsType],[incnAdjContactId],[incnAdjAddressID],[incsPolicyNo],[incsClaimNo],[incnStackedTimes],
--	[incsComments],[incnInsured],[incnCovgAmt],[incnDeductible],[incnUnInsPolicyLimit],[incnUnderPolicyLimit],[incbPolicyTerm],[incbTotCovg],[incsPlaintiffOrDef],[incnPlaintiffIDOrDefendantID],
--	[incnTPAdminOrgID],[incnTPAdminAddID],[incnTPAdjContactID],[incnTPAdjAddID],[incsTPAClaimNo],[incnRecUserID],[incdDtCreated],[incnModifyUserID],[incdDtModified],[incnLevelNo],
--	[incnUnInsPolicyLimitAcc],[incnUnderPolicyLimitAcc],[incb100Per],[incnMVLeased],[incnPriority],[incbDelete],[incnauthtodefcoun],[incnauthtodefcounDt],[incbPrimary],[saga]
--)
--SELECT 
--	MAP.caseID					    as [incnCaseID],
--	MAP.incnInsContactID			as [incnInsContactID],
--	MAP.incnInsAddressID			as [incnInsAddressID],
--	null							as [incbCarrierHasLienYN],
--	(select intnInsuranceTypeID from [sma_MST_InsuranceType] where intsDscrptn = case when isnull(INS.policy_type,'')<>'' then INS.policy_type else 'Unspecified' end ) as [incnInsType], 
--	MAP.incnAdjContactId			as [incnAdjContactId],
--	MAP.incnAdjAddressID			as [incnAdjAddressID],
--	INS.policy					    as [incsPolicyNo],
--	INS.claim						as [incsClaimNo],
--	null							as [incnStackedTimes],
--    isnull('accept: ' + nullif(convert(varchar,INS.accept),'') + CHAR(13),'') +
--    isnull('actual: ' + nullif(convert(varchar,INS.actual),'') + CHAR(13),'') +
--    isnull('agent: ' + nullif(convert(varchar,INS.agent),'') + CHAR(13),'') +
--    isnull('date_settled: ' + nullif(convert(varchar,INS.date_settled),'') + CHAR(13),'') +
--    isnull('how_settled: ' + nullif(convert(varchar,INS.how_settled),'') + CHAR(13),'') +
--    isnull('maximum_amount: ' + nullif(convert(varchar,INS.maximum_amount),'') + CHAR(13),'') +
--    isnull('minimum_amount: ' + nullif(convert(varchar,INS.minimum_amount),'') + CHAR(13),'') +
--    isnull('policy: ' + nullif(convert(varchar,INS.policy),'') + CHAR(13),'') +
--    isnull('claim: ' + nullif(convert(varchar,INS.claim),'') + CHAR(13),'') +
--    isnull('insured: ' + nullif(convert(varchar,INS.insured),'') + CHAR(13),'') +
--    isnull('limits: ' + nullif(convert(varchar,INS.limits),'') + CHAR(13),'') +
--    isnull('comments : ' + nullif(convert(varchar,INS.comments),'') + CHAR(13),'') +
--	isnull('Value Date: ' + nullif(convert(varchar,Ud.Value_date,101),'') + CHAR(13),'') +
--	isnull('Requested Limits: ' + nullif(convert(varchar,Ud.Requested_Limits),'') + CHAR(13),'') +
--	isnull('Projected Settlement Date: ' + nullif(convert(varchar,Ud.Projected_Settlement_Date,101),'') + CHAR(13),'') +
--	isnull('Medpay: ' + nullif(convert(varchar,ud.Medpay),'') + CHAR(13),'') +
--	isnull('About Limits: ' + nullif(convert(varchar,Ud.About_Limits),'') + CHAR(13),'') +
--	isnull('ERISA Lien: ' + nullif(convert(varchar,Ud.ERISA_Lien),'') + CHAR(13),'') +
--	isnull('Subro Provider: ' + nullif(convert(varchar,Ud.Subro_Provider),'') + CHAR(13),'') +
--	isnull('Nurse Case Manager: ' + nullif(convert(varchar,Ud.Nurse_Case_Manager),'') + CHAR(13),'') +
--	isnull('NCM: ' + nullif(convert(varchar,Ud.NCM),'') + CHAR(13),'') +
--	isnull('Credit Attorney: ' + nullif(convert(varchar,Ud.Credit_Date,101),'') + CHAR(13),'') +
--	isnull('Credit Date: ' + nullif(convert(varchar,Ud.NCM),'') + CHAR(13),'') +
--	isnull('Red Folder Research: ' + nullif(convert(varchar,Ud.Red_Folder_Research),'') + CHAR(13),'') +
--	isnull('Is_there_a_John_Doe: ' + nullif(convert(varchar,Ud.Is_there_a_John_Doe),'') + CHAR(13),'') +
--	''							    as [incsComments],
--	MAP.incnInsured				    as [incnInsured],
--	INS.actual					    as [incnCovgAmt], 
--	null							as [incnDeductible],
--	lim.[high]						as [incnUnInsPolicyLimit],
--	lim.[low]						as [incnUnderPolicyLimit],
--	0							    as [incbPolicyTerm],
--	0							    as [incbTotCovg],
--	'P'							    as [incsPlaintiffOrDef],
----    ( select plnnPlaintiffID from sma_TRN_Plaintiff where plnnCaseID=MAP.caseID and plnbIsPrimary=1 )  
--	MAP.PlaintiffDefendantID	    as [incnPlaintiffIDOrDefendantID],
--	null			    as [incnTPAdminOrgID], 
--	null			    as [incnTPAdminAddID],
--	null			    as [incnTPAdjContactID],
--	null			    as [incnTPAdjAddID],
--	null			    as [incsTPAClaimNo],
--	368					as [incnRecUserID],
--    getdate()		    as [incdDtCreated],
--    null			    as [incnModifyUserID],
--    null			    as [incdDtModified],
--	null			    as [incnLevelNo],
--	null			    as [incnUnInsPolicyLimitAcc],
--	null			    as [incnUnderPolicyLimitAcc],
--	0					as [incb100Per],
--	null			    as [incnMVLeased],
--	null			    as [incnPriority],
--	0					as [incbDelete],
--	0					as [incnauthtodefcoun],
--	null			    as [incnauthtodefcounDt],
--	0					as [incbPrimary],
--	INS.insurance_id	as [saga]
--FROM NeedlesKMY.[dbo].[insurance_Indexed] INS
--LEFT JOIN NeedlesKMY.[dbo].[user_insurance_data] UD on INS.insurance_id=UD.insurance_id
--LEFT JOIN InsuranceLimMap LIM on LIM.case_num = ins.case_num and LIM.insurer_ID = ins.insurer_id
--JOIN [Insurance_Contacts_Helper] MAP on INS.insurance_id=MAP.insurance_id and MAP.pord='P'
--GO


---(2)--- Insurance of defendants
--INSERT INTO [sma_TRN_InsuranceCoverage] 
--(
--	[incnCaseID],[incnInsContactID],[incnInsAddressID],[incbCarrierHasLienYN],[incnInsType],[incnAdjContactId],[incnAdjAddressID],[incsPolicyNo],[incsClaimNo],[incnStackedTimes],
--	[incsComments],[incnInsured],[incnCovgAmt],[incnDeductible],[incnUnInsPolicyLimit],[incnUnderPolicyLimit],[incbPolicyTerm],[incbTotCovg],[incsPlaintiffOrDef],[incnPlaintiffIDOrDefendantID],
--	[incnTPAdminOrgID],[incnTPAdminAddID],[incnTPAdjContactID],[incnTPAdjAddID],[incsTPAClaimNo],[incnRecUserID],[incdDtCreated],[incnModifyUserID],[incdDtModified],[incnLevelNo],
--	[incnUnInsPolicyLimitAcc],[incnUnderPolicyLimitAcc],[incb100Per],[incnMVLeased],[incnPriority],[incbDelete],[incnauthtodefcoun],[incnauthtodefcounDt],[incbPrimary],[saga]
--)
--SELECT DISTINCT 
--	MAP.caseID					    as [incnCaseID],
--	MAP.incnInsContactID			as [incnInsContactID],
--	MAP.incnInsAddressID			as [incnInsAddressID],
--	null							as [incbCarrierHasLienYN],
--	(select intnInsuranceTypeID from [sma_MST_InsuranceType] where intsDscrptn = case when isnull(INS.policy_type,'')<>'' then INS.policy_type else 'Unspecified' end ) as [incnInsType], 
--	MAP.incnAdjContactId			as [incnAdjContactId],
--	MAP.incnAdjAddressID			as [incnAdjAddressID],
--	INS.policy					    as [incsPolicyNo],
--	INS.claim						as [incsClaimNo],
--	null							as [incnStackedTimes],
--    isnull('accept : ' + nullif(convert(varchar,INS.accept),'') + CHAR(13),'') +
--    isnull('actual : ' + nullif(convert(varchar,INS.actual),'') + CHAR(13),'') +
--    isnull('agent : ' + nullif(convert(varchar,INS.agent),'') + CHAR(13),'') +
--    isnull('date_settled : ' + nullif(convert(varchar,INS.date_settled),'') + CHAR(13),'') +
--    isnull('how_settled : ' + nullif(convert(varchar,INS.how_settled),'') + CHAR(13),'') +
--    isnull('maximum_amount : ' + nullif(convert(varchar,INS.maximum_amount),'') + CHAR(13),'') +
--    isnull('minimum_amount : ' + nullif(convert(varchar,INS.minimum_amount),'') + CHAR(13),'') +
--    isnull('policy : ' + nullif(convert(varchar,INS.policy),'') + CHAR(13),'') +
--    isnull('claim : ' + nullif(convert(varchar,INS.claim),'') + CHAR(13),'') +
--    isnull('insured : ' + nullif(convert(varchar,INS.insured),'') + CHAR(13),'') +
--    isnull('limits : ' + nullif(convert(varchar,INS.limits),'') + CHAR(13),'') +
--    isnull('comments : ' + nullif(convert(varchar,INS.comments),'') + CHAR(13),'') +
--	isnull('Value Date: ' + nullif(convert(varchar,Ud.Value_date,101),'') + CHAR(13),'') +
--	isnull('Requested Limits: ' + nullif(convert(varchar,Ud.Requested_Limits),'') + CHAR(13),'') +
--	isnull('Projected Settlement Date: ' + nullif(convert(varchar,Ud.Projected_Settlement_Date,101),'') + CHAR(13),'') +
--	isnull('Medpay: ' + nullif(convert(varchar,ud.Medpay),'') + CHAR(13),'') +
--	isnull('About Limits: ' + nullif(convert(varchar,Ud.About_Limits),'') + CHAR(13),'') +
--	isnull('ERISA Lien: ' + nullif(convert(varchar,Ud.ERISA_Lien),'') + CHAR(13),'') +
--	isnull('Subro Provider: ' + nullif(convert(varchar,Ud.Subro_Provider),'') + CHAR(13),'') +
--	isnull('Nurse Cas Manager: ' + nullif(convert(varchar,Ud.Nurse_Case_Manager),'') + CHAR(13),'') +
--	isnull('NCM: ' + nullif(convert(varchar,Ud.NCM),'') + CHAR(13),'') +
--	isnull('Credit Attorney: ' + nullif(convert(varchar,Ud.Credit_Date,101),'') + CHAR(13),'') +
--	isnull('Credit Date: ' + nullif(convert(varchar,Ud.NCM),'') + CHAR(13),'') +
--	isnull('Red Folder Research: ' + nullif(convert(varchar,Ud.Red_Folder_Research),'') + CHAR(13),'') +
--	isnull('Is_there_a_John_Doe: ' + nullif(convert(varchar,Ud.Is_there_a_John_Doe),'') + CHAR(13),'') +
--	''							    as [incsComments],
--    MAP.incnInsured					as [incnInsured],
--    INS.actual					    as [incnCovgAmt], 
--    null							as [incnDeductible],
--	lim.[high]						as [incnUnInsPolicyLimit],
--	lim.[low]						as [incnUnderPolicyLimit],
--    0							    as [incbPolicyTerm],
--    0							    as [incbTotCovg],
--    'D'							    as [incsPlaintiffOrDef],
--	MAP.PlaintiffDefendantID	    as [incnPlaintiffIDOrDefendantID],
--    null							as [incnTPAdminOrgID], 
--    null			    as [incnTPAdminAddID],
--    null			    as [incnTPAdjContactID],
--    null			    as [incnTPAdjAddID],
--    null			    as [incsTPAClaimNo],
--    368					as [incnRecUserID],
--    getdate()		    as [incdDtCreated],
--    null			    as [incnModifyUserID],
--    null			    as [incdDtModified],
--    null			    as [incnLevelNo],
--	null			    as [incnUnInsPolicyLimitAcc],
--    null			    as [incnUnderPolicyLimitAcc],
--    0					as [incb100Per],
--    null			    as [incnMVLeased],
--    null			    as [incnPriority],
--    0					as [incbDelete],
--    0					as [incnauthtodefcoun],
--    null			    as [incnauthtodefcounDt],
--    0					as [incbPrimary],
--	INS.insurance_id	as [saga]
--FROM NeedlesKMY.[dbo].[insurance_Indexed] INS
--LEFT JOIN NeedlesKMY.[dbo].[user_insurance_data] UD on INS.insurance_id=UD.insurance_id
--LEFT JOIN InsuranceLimMap LIM on LIM.case_num = ins.case_num and LIM.insurer_ID = ins.insurer_id
--JOIN [Insurance_Contacts_Helper] MAP on INS.insurance_id=MAP.insurance_id and MAP.pord='D'
GO
---
ALTER TABLE [sma_TRN_InsuranceCoverage] ENABLE TRIGGER ALL
GO
---


---(Adjuster/Insurer association)---
INSERT INTO [sma_MST_RelContacts]
(
       [rlcnPrimaryCtgID]
      ,[rlcnPrimaryContactID]
      ,[rlcnPrimaryAddressID]
      ,[rlcnRelCtgID]
      ,[rlcnRelContactID]
      ,[rlcnRelAddressID]
      ,[rlcnRelTypeID]
      ,[rlcnRecUserID]
      ,[rlcdDtCreated]
      ,[rlcnModifyUserID]
      ,[rlcdDtModified]
      ,[rlcnLevelNo]
      ,[rlcsBizFam]
      ,[rlcnOrgTypeID]
)
SELECT DISTINCT
	1						 as [rlcnPrimaryCtgID],
	IC.[incnAdjContactId]	 as [rlcnPrimaryContactID],
	IC.[incnAdjAddressID]	 as [rlcnPrimaryAddressID],
	2						 as [rlcnRelCtgID],
	IC.[incnInsContactID]	 as [rlcnRelContactID],
	IC.[incnAdjAddressID]	 as [rlcnRelAddressID],
	2						 as [rlcnRelTypeID],
	368						 as [rlcnRecUserID],
	getdate()				 as [rlcdDtCreated],
	null					 as [rlcnModifyUserID],
	null					 as [rlcdDtModified],
	null					 as [rlcnLevelNo],
	'Business'				 as [rlcsBizFam],
	null					 as [rlcnOrgTypeID]
FROM [sma_TRN_InsuranceCoverage] IC
WHERE isnull(IC.[incnAdjContactId],0)<>0 and isnull(IC.[incnInsContactID],0)<>0  


------------------------------
--INSURANCE ADJUSTERS
------------------------------
INSERT INTO [sma_TRN_InsuranceCoverageAdjusters] (insuranceCoverageID, AdjusterContactUID)
SELECT incnInsCovgID, ioc2.UNQCID
FROM sma_TRN_InsuranceCoverage ic
JOIN IndvOrgContacts_Indexed IOC2 on IOC2.cid = ic.incnAdjContactId and ioc2.aid = ic.[incnAdjAddressID]
LEFT JOIN sma_TRN_InsuranceCoverageAdjusters ca on ca.InsuranceCoverageId = incnInsCovgID
						and ca.AdjusterContactUID = ioc2.UNQCID
WHERE ca.InsuranceCoverageId is null