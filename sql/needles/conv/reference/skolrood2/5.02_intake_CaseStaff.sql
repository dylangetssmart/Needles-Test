ALTER TABLE [sma_TRN_caseStaff] DISABLE TRIGGER ALL
GO

------------------------------------------------------------------------------
-- Convert staff_1 ###########################################################
------------------------------------------------------------------------------
insert into sma_TRN_caseStaff 
(
       [cssnCaseID]
      ,[cssnStaffID]
      ,[cssnRoleID]
      ,[csssComments]
      ,[cssdFromDate]
      ,[cssdToDate]
      ,[cssnRecUserID]
      ,[cssdDtCreated]
      ,[cssnModifyUserID]
      ,[cssdDtModified]
      ,[cssnLevelNo]
)
select 
	C.casnCaseID			    as [cssnCaseID]
	,U.usrnContactID            as [cssnStaffID]
	,(
        select sbrnSubRoleId
        from sma_MST_SubRole
        where sbrsDscrptn = 'Staff' and sbrnRoleID = 10
    )                           as [cssnRoleID]
	,null					    as [csssComments]
	,null					    as cssdFromDate
	,null                       as cssdToDate
	,368                        as cssnRecUserID
	,getdate()				    as [cssdDtCreated]
	,null					    as [cssnModifyUserID]
	,null					    as [cssdDtModified]
	,0					        as cssnLevelNo
FROM NeedlesSLF.[dbo].case_intake N
JOIN [sma_TRN_Cases] C
    on C.saga = N.ROW_ID
inner join [sma_MST_Users] U
    on U.saga = N.staff_1
where isnull(N.staff_1,'') <> ''

ALTER TABLE [sma_TRN_caseStaff] ENABLE TRIGGER ALL
GO