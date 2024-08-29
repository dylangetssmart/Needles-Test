-- USE SANeedlesSLF
GO

--case staff
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
SELECT DISTINCT
	CAS.casnCaseID				as [cssnCaseID]
	,U.usrnContactID			as [cssnStaffID]
	,(
		select sbrnSubRoleId
		from sma_MST_SubRole
		where sbrsDscrptn='Staff' and sbrnRoleID=10
	)							as [cssnRoleID]
	,null						as [csssComments]
	,null						as cssdFromDate
	,null						as cssdToDate
	,368						as cssnRecUserID
	,getdate()					as [cssdDtCreated]
	,null						as [cssnModifyUserID]
	,null						as [cssdDtModified]
	,0							as cssnLevelNo
FROM NeedlesSLF.[dbo].[case_intake] c
	JOIN [sma_TRN_cases] CAS on CAS.saga = C.row_ID
	JOIN [sma_MST_Users] U on ( U.saga = C.staff_1 )
	LEFT JOIN sma_TRN_caseStaff cs
		on cs.[cssnStaffID] = u.usrnContactID
		and cs.[cssnCaseID] = CAS.casnCaseID
		and [cssnRoleID] = (
							select sbrnSubRoleId
							from sma_MST_SubRole
							where sbrsDscrptn='Staff' and sbrnRoleID=10
							)
WHERE isnull(c.staff_1,'') <> ''
and cs.cssnPKID IS NULL
