-- use SANeedlesSLF
go
/*
alter table [sma_TRN_CriticalComments] disable trigger all
delete from [sma_TRN_CriticalComments] 
DBCC CHECKIDENT ('[sma_TRN_CriticalComments]', RESEED, 0);
alter table [sma_TRN_CriticalComments] enable trigger all
*/

INSERT INTO [sma_TRN_CriticalComments]
(
       [ctcnCaseID]
      ,[ctcnCommentTypeID]
      ,[ctcsText]
      ,[ctcbActive]
      ,[ctcnRecUserID]
      ,[ctcdDtCreated]
      ,[ctcnModifyUserID]
      ,[ctcdDtModified]
      ,[ctcnLevelNo]
      ,[ctcsCommentType]
)
SELECT 
    CAS.casnCaseID	    as [ctcnCaseID],
    0					as [ctcnCommentTypeID],
    special_note	    as [ctcsText],
    1					as [ctcbActive],
    (
		select usrnUserID
		from sma_MST_Users
		where saga=C.staff_1
	)					as [ctcnRecUserID],
    case
		when date_of_incident between '1900-01-01' and '2079-06-01'
			then date_of_incident
		else NULL
		end				as [ctcdDtCreated],
    null			    as [ctcnModifyUserID],
    null			    as [ctcdDtModified],
    null			    as [ctcnLevelNo],
    null			    as [ctcsCommentType]
FROM NeedlesSLF.[dbo].[cases_Indexed] C
JOIN [sma_trn_cases] CAS
	on CAS.cassCaseNumber=C.casenum
WHERE isnull(special_note,'')<>''