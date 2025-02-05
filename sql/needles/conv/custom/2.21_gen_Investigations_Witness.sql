use TestNeedles
alter table [TestNeedles].[dbo].[sma_TRN_CaseWitness] disable trigger all
---
----(1)----
insert into [TestNeedles].[dbo].[sma_TRN_CaseWitness]
(
	   [witnCaseID]
      ,[witnWitnesContactID]
      ,[witnWitnesAdID]
      ,[witnRoleID]
      ,[witnFavorable]
      ,[witnTestify]
      ,[witdStmtReqDate]
      ,[witdStmtDate]
      ,[witbHasRec]
      ,[witsDoc]
      ,[witsComment]
      ,[witnRecUserID]
      ,[witdDtCreated]
      ,[witnModifyUserID]
      ,[witdDtModified]
      ,[witnLevelNo]
)

select distinct 
	c.casnCaseID		as [witnCaseID]
	,ioc.CID			as [witnWitnesContactID]
	,ioc.AID			as [witnWitnesAdID]
	,null				as [witnRoleID]
	,null				as [witnFavorable]
	,null				as [witnTestify]
	,null				as [witdStmtReqDate]
	,null				as [witdStmtDate]
	,null				as [witbHasRec]
	,null				as [witsDoc]
    ,null 				as [witsComment]
	,368				as [witnRecUserID]
	,getdate()			as [witdDtCreated]
	,null				as [witnModifyUserID]
	,null				as [witdDtModified]
	,null				as [witnLevelNo]
from TestNeedles..user_party_data upd
	join TestNeedles..IndvOrgContacts_Indexed ioc
		on ioc.saga = upd.case_id
	inner join TestNeedles..sma_MST_IndvContacts ic
		on ic.cinnContactID = ioc.CID
		and ic.saga_ref = 'witness'
	join TestNeedles..sma_TRN_Cases c
		ON c.cassCaseNumber = CONVERT(VARCHAR, upd.case_id)
where isnull(upd.Witness_1,'') <> '' or isnull(upd.Witness_2,'') <> '' or isnull(upd.Witness_3,'') <> ''
GO

---
alter table [TestNeedles].[dbo].[sma_TRN_CaseWitness] enable trigger all
---
