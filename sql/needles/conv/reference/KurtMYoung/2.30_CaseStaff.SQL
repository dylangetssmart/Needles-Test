use [SANeedlesKMY]
go
/*
alter table [sma_TRN_caseStaff] disable trigger all
delete [sma_TRN_caseStaff]
DBCC CHECKIDENT ('[sma_TRN_caseStaff]', RESEED, 0);
alter table [sma_TRN_caseStaff] enable trigger all

select cssnCaseID,count(cssnCaseID) from [sma_TRN_caseStaff] 
group by cssnCaseID
having count(cssnCaseID)=9

*/


----(0) staff roles ----
-- Add the following roles into sma_MST_SubRoleCode if they do not exist
INSERT INTO [sma_MST_SubRoleCode]
(
	srcsDscrptn
	,srcnRoleID
)
(
	--In Needles, box 1 = paralegal, box 2 = attorney, box 3 = negotiator, box 4 = clerical.  Also, box 6 = prior paralegal, box 7 = prior attorney.  Can the roles be imported?
	SELECT 'Attorney',10
	UNION ALL
	SELECT 'Intake Paralegal',10
	UNION ALL
	SELECT 'Primary Paralegal',10
	UNION ALL
	SELECT 'Primary Attorney',10
)
EXCEPT SELECT srcsDscrptn, srcnRoleID from [sma_MST_SubRoleCode]



ALTER TABLE [sma_TRN_caseStaff] DISABLE TRIGGER ALL
GO


/*
Hardcode staff_1 through staff_10 with "Staff"
*/

-- Declare variables
DECLARE @i INT = 1;
DECLARE @sql NVARCHAR(MAX);
DECLARE @staffColumn NVARCHAR(20);

-- Loop through staff_1 to staff_10
WHILE @i <= 10
BEGIN
    -- Set the current staff column
    SET @staffColumn = 'staff_' + CAST(@i AS NVARCHAR(2));

    -- Create the dynamic SQL query
    SET @sql = '
    INSERT INTO sma_TRN_caseStaff 
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
    SELECT 
        CAS.casnCaseID              as [cssnCaseID],
        U.usrnContactID             as [cssnStaffID],
        (
            select sbrnSubRoleId
            from sma_MST_SubRole
            where sbrsDscrptn=''Staff'' and sbrnRoleID=10
        )                           as [cssnRoleID],
        null                        as [csssComments],
        null                        as cssdFromDate,
        null                        as cssdToDate,
        368                         as cssnRecUserID,
        getdate()                   as [cssdDtCreated],
        null                        as [cssnModifyUserID],
        null                        as [cssdDtModified],
        0                           as cssnLevelNo
    FROM NeedlesKMY.[dbo].[cases_Indexed] C
    JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
    JOIN [sma_MST_Users] U on ( U.saga = C.' + @staffColumn + ' )
    ';

    -- Execute the dynamic SQL query
    EXEC sp_executesql @sql;

    -- Increment the counter
    SET @i = @i + 1;
END
GO

/*
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
	CAS.casnCaseID			  as [cssnCaseID],
	U.usrnContactID		  as [cssnStaffID],
	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
	null					  as [csssComments],
	null					  as cssdFromDate,
	null					  as cssdToDate,
	368					  as cssnRecUserID,
	getdate()				  as [cssdDtCreated],
	null					  as [cssnModifyUserID],
	null					  as [cssdDtModified],
	0					  as cssnLevelNo
FROM NeedlesKMY.[dbo].[cases_Indexed] C
inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_1 )
*/

--------------------
----STAFF 2
--------------------
--INSERT INTO sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--SELECT 
--	CAS.casnCaseID				as [cssnCaseID],
--	U.usrnContactID				as [cssnStaffID],
--	(
--		select sbrnSubRoleId
--		from sma_MST_SubRole
--		where sbrsDscrptn='Primary Paralegal' and sbrnRoleID=10
--	)							as [cssnRoleID],
--	null						as [csssComments],
--	null						as cssdFromDate,
--	null						as cssdToDate,
--	368							as cssnRecUserID,
--	getdate()					as [cssdDtCreated],
--	null						as [cssnModifyUserID],
--	null						as [cssdDtModified],
--	0							as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--JOIN [sma_MST_Users] U on ( U.saga = C.staff_2 )

--------------------
----STAFF 3
--------------------
--INSERT INTO sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--SELECT 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(
--		select sbrnSubRoleId
--		from sma_MST_SubRole
--		where sbrsDscrptn='Primary Attorney' and sbrnRoleID=10
--	)					 	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--JOIN [sma_MST_Users] U on ( U.saga = C.staff_3 )

--/*
--------------------
----STAFF 4
--------------------
--insert into sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--select 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_4 )


--------------------
----STAFF 5
--------------------
--insert into sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--select 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_5 )
--*/

--------------------
----STAFF 6
--------------------
--INSERT INTO sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--SELECT 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Attorney' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--JOIN [sma_MST_Users] U on ( U.saga = C.staff_6 )

--/*
--------------------
----STAFF 7
--------------------
--insert into sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--select 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_7 )


--------------------
----STAFF 8
--------------------
--insert into sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--select 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_8 )
--*/

--------------------
----STAFF 9
--------------------
--INSERT INTO sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--SELECT 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Intake Paralegal' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--JOIN sma_TRN_cases CAS on CAS.cassCaseNumber = C.casenum
--JOIN sma_MST_Users U on ( U.saga = C.staff_9 )

--/*
--------------------
----STAFF 10
--------------------
--insert into sma_TRN_caseStaff 
--(
--       [cssnCaseID]
--      ,[cssnStaffID]
--      ,[cssnRoleID]
--      ,[csssComments]
--      ,[cssdFromDate]
--      ,[cssdToDate]
--      ,[cssnRecUserID]
--      ,[cssdDtCreated]
--      ,[cssnModifyUserID]
--      ,[cssdDtModified]
--      ,[cssnLevelNo]
--)
--select 
--	CAS.casnCaseID			  as [cssnCaseID],
--	U.usrnContactID		  as [cssnStaffID],
--	(select sbrnSubRoleId from sma_MST_SubRole where sbrsDscrptn='Staff' and sbrnRoleID=10 )	 as [cssnRoleID],
--	null					  as [csssComments],
--	null					  as cssdFromDate,
--	null					  as cssdToDate,
--	368					  as cssnRecUserID,
--	getdate()				  as [cssdDtCreated],
--	null					  as [cssnModifyUserID],
--	null					  as [cssdDtModified],
--	0					  as cssnLevelNo
--FROM NeedlesKMY.[dbo].[cases_Indexed] C
--inner join [SA].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = C.casenum
--inner join [SA].[dbo].[sma_MST_Users] U on ( U.saga = C.staff_10 )
--*/


---
ALTER TABLE [sma_TRN_caseStaff] ENABLE TRIGGER ALL
GO
---


