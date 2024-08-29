use SANeedlesKMY

insert into [dbo].[sma_TRN_CaseWitness] (
	--[witnWitnesID]
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
SELECT
	--@NextID + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS [witnWitnesID]
	cas.casnCaseID			as [witnCaseID]
	,ioci.UNQCID			as [witnWitnesContactID]
	,ioci.aid				as [witnWitnesAdID]
	,null					as [witnRoleID]
	,null					as [witnFavorable]
	,null					as [witnTestify]
	,null					as [witdStmtReqDate]
	,null					as [witdStmtDate]
	,null					as [witbHasRec]
	,null					as [witsDoc]
	,null					as [witsComment]
	,368					as [witnRecUserID]
	,getDate()				as [witdDtCreated]
	,null					as [witnModifyUserID]
	,null					as [witdDtModified]
	,null					as [witnLevelNo]
FROM NeedlesKMY..user_tab_data utd
	JOIN sma_trn_Cases cas
		on cas.cassCaseNumber = convert(varchar,utd.case_id)
	-- Link to SA Contact Card via:
	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
	join NeedlesKMY.dbo.user_tab_name utn
		on utd.tab_id = utn.tab_id
	join NeedlesKMY.dbo.names n
		on utn.user_name = n.names_id
	left join IndvOrgContacts_Indexed ioci
		on n.names_id = ioci.saga
		and ioci.CTG = 1
WHERE isnull(utd.witness_name,'')<>''