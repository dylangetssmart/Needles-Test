use [SANeedlesKMY]
--GO
--/*
--alter table [sma_TRN_Hospitals] disable trigger all
--delete [sma_TRN_Hospitals]
--DBCC CHECKIDENT ('[sma_TRN_Hospitals]', RESEED, 0);
--alter table [sma_TRN_Hospitals] enable trigger all

--alter table [sma_TRN_SpDamages] disable trigger all
--delete [sma_TRN_SpDamages]
--DBCC CHECKIDENT ('[sma_TRN_SpDamages]', RESEED, 0);
--alter table [sma_TRN_SpDamages] enable trigger all

--alter table [sma_TRN_SpecialDamageAmountPaid] disable trigger all
--delete [sma_TRN_SpecialDamageAmountPaid]
--DBCC CHECKIDENT ('[sma_TRN_SpecialDamageAmountPaid]', RESEED, 0);
--alter table [sma_TRN_SpecialDamageAmountPaid] enable trigger all
--*/

----select distinct code, description from NeedlesKMY.[dbo].[value] order by code
-------------

--alter table [sma_TRN_Hospitals] disable trigger all
--GO
--alter table [sma_TRN_SpDamages] disable trigger all
--GO
--alter table [sma_TRN_SpecialDamageAmountPaid] disable trigger all
--GO


-----(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Hospitals'))
begin
    ALTER TABLE [sma_TRN_Hospitals] ADD [saga] [varchar](100) NULL; 
end
GO


alter table [sma_TRN_Hospitals] disable trigger all


/* ####################################
1.0 -- user_case_data.Attending_Physician
*/
                

insert into [sma_TRN_Hospitals]
 (	[hosnCaseID], 
	[hosnContactID], 
	[hosnContactCtg],
	[hosnAddressID], 
	[hossMedProType], 
	[hosdStartDt],
	[hosdEndDt],
	[hosnPlaintiffID],
	[hosnComments], 
	[hosnHospitalChart], 
	[hosnRecUserID],
	[hosdDtCreated], 
	[hosnModifyUserID],
	[hosdDtModified],
	[saga]
)
select
    cas.casnCaseID				as [hosnCaseID], 
    ioc.cid						as [hosnContactID],
    ioc.CTG						as [hosnContactCtg],
    ioc.AID						as [hosnAddressID], 
    'M'							as [hossMedProType],
    null						as [hosdStartDt],
    null						as [hosdEndDt],
    p.plnnPlaintiffID			as hosnPlaintiffID,
    null						as [hosnComments],
    null						as [hosnHospitalChart],
    368							as [hosnRecUserID],
    getdate()					as [hosdDtCreated],
    null						as [hosnModifyUserID],
    null						as [hosdDtModified],
    n.names_id					as [saga]
from NeedlesKMY..user_case_data ud
	-- case
	join NeedlesKMY..cases c
		on c.casenum = convert(varchar, ud.casenum)
	join sma_TRN_Cases cas
		on cas.cassCaseNumber = convert(varchar, ud.casenum)
	-- Doctor contact card
	join NeedlesKMY..user_case_name un
		on un.casenum = ud.casenum
	join NeedlesKMY..user_case_matter um
		on um.ref_num = un.ref_num
		and um.mattercode = c.matcode
		and um.field_title = 'Attending Physician'
	join NeedlesKMY..names n
		on n.names_id = un.user_name
	join SANeedlesKMY..IndvOrgContacts_Indexed ioc
		on ioc.SAGA = n.names_id
	-- get Plaintiff
	join sma_TRN_Plaintiff p
		on p.plnnCaseID = cas.casnCaseID

where isnull(ud.Attending_Physician,'') <> ''

--FROM NeedlesKMY..user_case_data ucd
--	JOIN sma_trn_Cases cas
--		on cas.cassCaseNumber = convert(varchar,ucd.casenum)
--	-- Link to SA Contact Card via:
--	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
--	join NeedlesKMY.dbo.user_case_name ucn
--		on ucd.casenum = ucn.casenum
--	join NeedlesKMY.dbo.names n
--		on ucn.user_name = n.names_id
--	left join IndvOrgContacts_Indexed ioci
--		on n.names_id = ioci.saga
--		and ioci.CTG = 1
--	join [sma_TRN_Plaintiff] pln
--		on pln.plnnCaseID = cas.casnCaseID
--WHERE isnull(ucd.Attending_Physician,'')<>''



alter table [sma_TRN_Hospitals] enable trigger all