-- USE [SANeedlesSLF]
GO
/*
alter table [sma_TRN_ReferredOut] disable trigger all
delete [sma_TRN_ReferredOut]
DBCC CHECKIDENT ('[sma_TRN_ReferredOut]', RESEED, 0);
alter table [sma_TRN_ReferredOut] enable trigger all

select * from [sma_TRN_ReferredOut]
*/

--(1)--
INSERT INTO [sma_TRN_ReferredOut]
(
    rfosType,
    rfonCaseID,
    rfonPlaintiffID,
    rfonLawFrmContactID,
    rfonLawFrmAddressID,
    rfonAttContactID,
    rfonAttAddressID,
    rfonGfeeAgreement,
    rfobMultiFeeStru,
    rfobComplexFeeStru,
    rfonReferred,
    rfonCoCouncil,
    rfonIsLawFirmUpdateToSend
)

SELECT
    'G'						as rfosType,
    CAS.casnCaseID			as rfonCaseID,
    -1						as rfonPlaintiffID,
	case
		when IOC.CTG=2
			then IOC.CID	
		else null
		end					as rfonLawFrmContactID,
	case
		when IOC.CTG=2
			then IOC.AID	
		else null
		end					as rfonLawFrmAddressID,
	case
		when IOC.CTG=1
			then IOC.CID	
		else null
		end					as rfonAttContactID,
	case
		when IOC.CTG=1
			then IOC.AID	
		else null
		end 				as rfonAttAddressID,
    0						as rfonGfeeAgreement,
    0						as rfobMultiFeeStru,
    0						as rfobComplexFeeStru,
    1						as rfonReferred,
    0						as rfonCoCouncil,
    0						as rfonIsLawFirmUpdateToSend
FROM NeedlesSLF.[dbo].[cases_indexed] C
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = C.casenum
JOIN [IndvOrgContacts_Indexed] IOC
	on IOC.SAGA=C.referred_to_id
		and C.referred_to_id > 0


--(2)--
UPDATE sma_MST_IndvContacts 
SET cinnContactTypeID = (select octnOrigContactTypeID from [dbo].[sma_MST_OriginalContactTypes] where octsDscrptn='Attorney')
WHERE cinnContactID in ( select rfonAttContactID from sma_TRN_ReferredOut where isnull(rfonAttContactID,'')<>'' )


