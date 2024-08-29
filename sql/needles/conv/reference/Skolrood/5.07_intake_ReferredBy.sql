-- USE SANeedlesSLF
-- GO

INSERT INTO [sma_TRN_OtherReferral]
(
       [otrnCaseID]
      ,[otrnRefContactCtg]
      ,[otrnRefContactID]
      ,[otrnRefAddressID]
      ,[otrnPlaintiffID]
      ,[otrsComments]
      ,[otrnUserID]
      ,[otrdDtCreated]
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
--select referred_by, referred_by_id
FROM NeedlesSLF..case_intake c
	JOIN [sma_TRN_cases] CAS
		on CAS.saga = C.row_id
	JOIN [IndvOrgContacts_Indexed] IOC
		on IOC.SAGA = C.referred_by_id
		and C.referred_by_id > 0
WHERE isnull(referred_by,'') <> ''
