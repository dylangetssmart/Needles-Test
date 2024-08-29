-- use SANeedlesSLF
go
/*
alter table [sma_TRN_OtherReferral] disable trigger all
delete [sma_TRN_OtherReferral]
DBCC CHECKIDENT ('[sma_TRN_OtherReferral]', RESEED, 0);
alter table [sma_TRN_OtherReferral] enable trigger all
*/

--(1)--

INSERT INTO [sma_TRN_OtherReferral]
(
      [otrnCaseID],
      [otrnRefContactCtg],
      [otrnRefContactID],
      [otrnRefAddressID],
      [otrnPlaintiffID],
      [otrsComments],
      [otrnUserID],
      [otrdDtCreated]
)
SELECT
    CAS.casnCaseID	as [otrnCaseID],
    IOC.CTG		    as [otrnRefContactCtg],
    IOC.CID		    as [otrnRefContactID],
    IOC.AID			as [otrnRefAddressID],
    -1			    as [otrnPlaintiffID],
    null			as [otrsComments],
    368			    as [otrnUserID], 
    getdate()		as [otrdDtCreated] 
FROM NeedlesSLF.[dbo].[cases_indexed] C
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = C.casenum
JOIN [IndvOrgContacts_Indexed] IOC
	on IOC.SAGA=C.referred_link
		and C.referred_link > 0
