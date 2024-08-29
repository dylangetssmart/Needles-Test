
USE SANeedlesKMY
GO
/*
alter table [sma_TRN_Defendants] disable trigger all
delete from [sma_TRN_Defendants] 
DBCC CHECKIDENT ('[sma_TRN_Defendants]', RESEED, 0);
alter table [sma_TRN_Defendants] enable trigger all

alter table [sma_TRN_Plaintiff] disable trigger all
delete from [sma_TRN_Plaintiff] 
DBCC CHECKIDENT ('[sma_TRN_Plaintiff]', RESEED, 0);
alter table [sma_TRN_Plaintiff] enable trigger all

select * from [sma_TRN_Plaintiff] enable trigger all
*/

-------------------------------------------------------------------------------
-- Initialize #################################################################
-- Add [saga_party] to [sma_TRN_Plaintiff]and [sma_TRN_Defendants]
-------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga_party' AND Object_ID = Object_ID(N'sma_TRN_Plaintiff'))
BEGIN
    ALTER TABLE [sma_TRN_Plaintiff] ADD [saga_party] int NULL; 
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga_party' AND Object_ID = Object_ID(N'sma_TRN_Defendants'))
BEGIN
    ALTER TABLE [sma_TRN_Defendants] ADD [saga_party] int NULL; 
END

-- Disable table triggers
ALTER TABLE [sma_TRN_Plaintiff] DISABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Defendants] DISABLE TRIGGER ALL
GO

-------------------------------------------------------------------------------
-- Construct sma_TRN_Plaintiff ################################################
-- 
-------------------------------------------------------------------------------

INSERT INTO [sma_TRN_Plaintiff] (
	[plnnCaseID]
	,[plnnContactCtg]
	,[plnnContactID]
	,[plnnAddressID]
	,[plnnRole]
	,[plnbIsPrimary]
	,[plnbWCOut]
	,[plnnPartiallySettled]
	,[plnbSettled]
	,[plnbOut]
	,[plnbSubOut]
	,[plnnSeatBeltUsed]
	,[plnnCaseValueID]
	,[plnnCaseValueFrom]
	,[plnnCaseValueTo]
	,[plnnPriority]
	,[plnnDisbursmentWt]
	,[plnbDocAttached]
	,[plndFromDt]
	,[plndToDt]
	,[plnnRecUserID]
	,[plndDtCreated]
	,[plnnModifyUserID]
	,[plndDtModified]
	,[plnnLevelNo]
	,[plnsMarked]
	,[saga]
	,[plnnNoInj]
	,[plnnMissing]
	,[plnnLIPBatchNo]
	,[plnnPlaintiffRole]
	,[plnnPlaintiffGroup]
	,[plnnPrimaryContact]
	,[saga_party]
	)
SELECT CAS.casnCaseID AS [plnnCaseID]
	,CIO.CTG AS [plnnContactCtg]
	,CIO.CID AS [plnnContactID]
	,CIO.AID AS [plnnAddressID]
	,S.sbrnSubRoleId AS [plnnRole]
	,1 AS [plnbIsPrimary]
	,0
	,0
	,0
	,0
	,0
	,0
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,GETDATE()
	,NULL
	,368 AS [plnnRecUserID]
	,GETDATE() AS [plndDtCreated]
	,NULL
	,NULL
	,NULL AS [plnnLevelNo]
	,NULL
	,''
	,NULL
	,NULL
	,NULL
	,NULL
	,NULL
	,1 AS [plnnPrimaryContact]
	,P.TableIndex AS [saga_party]
--SELECT cas.casncaseid, p.role, p.party_ID, pr.[needles roles], pr.[sa roles], pr.[sa party], s.*
FROM NeedlesKMY.[dbo].[party_indexed] P
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = P.case_id  
	JOIN IndvOrgContacts_Indexed CIO
		on CIO.SAGA = P.party_id
	JOIN [PartyRoles] pr
		on pr.[Needles Roles] = p.[role]
	JOIN [sma_MST_SubRole] S
		on CAS.casnOrgCaseTypeID = S.sbrnCaseTypeID
			and s.sbrsDscrptn = [sa roles]
			and  S.sbrnRoleID=4
WHERE pr.[sa party] = 'Plaintiff' 
GO

/*
select * from [sma_MST_SubRole]
---( Now. do special role assignment )
DECLARE @needles_role varchar(100);
DECLARE @sa_role varchar(100);
DECLARE role_cursor CURSOR FOR 
SELECT [Needles Roles],[SA Roles] FROM [SA].[dbo].[PartyRoles] where [SA Party]='Plaintiff'
 
OPEN role_cursor 
FETCH NEXT FROM role_cursor INTO @needles_role,@sa_role
WHILE @@FETCH_STATUS = 0
BEGIN

    update [SA].[dbo].[sma_TRN_Plaintiff] set plnnRole=S.sbrnSubRoleId
    from NeedlesKMY.[dbo].[party_indexed] P 
    inner join [SA].[dbo].[sma_TRN_Cases] CAS on CAS.cassCaseNumber = P.case_id  
    inner join [SA].[dbo].[sma_MST_SubRole] S on CAS.casnOrgCaseTypeID = S.sbrnCaseTypeID and S.sbrnRoleID=4 and S.sbrsDscrptn=@sa_role
    inner join IndvOrgContacts_Indexed CIO on CIO.SAGA = P.party_id
    where P.role=@needles_role
    and P.TableIndex=saga_party 

FETCH NEXT FROM role_cursor INTO @needles_role,@sa_role
END 
CLOSE role_cursor;
DEALLOCATE role_cursor;


GO
*/



/*
-------------------------------------------------------------------------------
-- Construct sma_TRN_Defendants ###############################################
from party_indexed
with cases that exist in trn_cases
IndvOrgContacts_Indexed
[Needles Roles]
[sma_MST_SubRole]
-------------------------------------------------------------------------------
*/

insert into [sma_TRN_Defendants] (
	[defnCaseID]
	,[defnContactCtgID]
	,[defnContactID]
	,[defnAddressID]
	,[defnSubRole]
	,[defbIsPrimary]
	,[defbCounterClaim]
	,[defbThirdParty]
	,[defsThirdPartyRole]
	,[defnPriority]
	,[defdFrmDt]
	,[defdToDt]
	,[defnRecUserID]
	,[defdDtCreated]
	,[defnModifyUserID]
	,[defdDtModified]
	,[defnLevelNo]
	,[defsMarked]
	,[saga]
	,[saga_party]
	)
select casnCaseID								as [defnCaseID]
	,ACIO.CTG									as [defnContactCtgID]
	,ACIO.CID									as [defnContactID]
	,ACIO.AID									as [defnAddressID]
	,sbrnSubRoleId								as [defnSubRole]
	,1											as [defbIsPrimary]
	,null
	,null
	,null
	,null
	,null
	,null
	,368										as [defnRecUserID]
	,GETDATE()									as [defdDtCreated]
	,null										as [defnModifyUserID]
	,null										as [defdDtModified]
	,null										as [defnLevelNo]
	,null
	,null
	,P.TableIndex								as [saga_party]
from NeedlesKMY.[dbo].[party_indexed] P
	join [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = P.case_id
	join IndvOrgContacts_Indexed ACIO
		on ACIO.SAGA = P.party_id
	join [PartyRoles] pr
		on pr.[Needles Roles] = p.[role]
	join [sma_MST_SubRole] S
		on CAS.casnOrgCaseTypeID = S.sbrnCaseTypeID
			and s.sbrsDscrptn = [sa roles]
			and S.sbrnRoleID = 5
where pr.[sa party] = 'Defendant'
go


/*
from NeedlesKMY.[dbo].[party_indexed] P 
inner join [SA].[dbo].[sma_TRN_Cases] C on C.cassCaseNumber = P.case_id  
inner join [SA].[dbo].[sma_MST_SubRole] S on C.casnOrgCaseTypeID = S.sbrnCaseTypeID
inner join IndvOrgContacts_Indexed ACIO on ACIO.SAGA = P.party_id
where S.sbrnRoleID=5 and S.sbrsDscrptn='(D)-Default Role'
and P.role in (SELECT [Needles Roles] FROM [SA].[dbo].[PartyRoles] where [SA Party]='Defendant')
GO

---( Now. do special role assignment )
DECLARE @needles_role varchar(100);
DECLARE @sa_role varchar(100);
DECLARE role_cursor CURSOR FOR 
SELECT [Needles Roles],[SA Roles] FROM [SA].[dbo].[PartyRoles] where [SA Party]='Defendant'
 
OPEN role_cursor 
FETCH NEXT FROM role_cursor INTO @needles_role,@sa_role
WHILE @@FETCH_STATUS = 0
BEGIN


    update [SA].[dbo].[sma_TRN_Defendants] set defnSubRole=S.sbrnSubRoleId
    from NeedlesKMY.[dbo].[party_indexed] P 
    inner join [SA].[dbo].[sma_TRN_Cases] C on C.cassCaseNumber = P.case_id  
    inner join [SA].[dbo].[sma_MST_SubRole] S on C.casnOrgCaseTypeID = S.sbrnCaseTypeID and S.sbrnRoleID=5 and S.sbrsDscrptn=@sa_role
    inner join IndvOrgContacts_Indexed ACIO on ACIO.SAGA = P.party_id
    where P.role=@needles_role
    and P.TableIndex=saga_party 

FETCH NEXT FROM role_cursor INTO @needles_role,@sa_role
END 
CLOSE role_cursor;
DEALLOCATE role_cursor;
GO
*/


/*
-------------------------------------------------------------------------------
##############################################################################
-------------------------------------------------------------------------------
---(Appendix A)-- every case need at least one plaintiff
*/

insert into [sma_TRN_Plaintiff] (
	[plnnCaseID]
	,[plnnContactCtg]
	,[plnnContactID]
	,[plnnAddressID]
	,[plnnRole]
	,[plnbIsPrimary]
	,[plnbWCOut]
	,[plnnPartiallySettled]
	,[plnbSettled]
	,[plnbOut]
	,[plnbSubOut]
	,[plnnSeatBeltUsed]
	,[plnnCaseValueID]
	,[plnnCaseValueFrom]
	,[plnnCaseValueTo]
	,[plnnPriority]
	,[plnnDisbursmentWt]
	,[plnbDocAttached]
	,[plndFromDt]
	,[plndToDt]
	,[plnnRecUserID]
	,[plndDtCreated]
	,[plnnModifyUserID]
	,[plndDtModified]
	,[plnnLevelNo]
	,[plnsMarked]
	,[saga]
	,[plnnNoInj]
	,[plnnMissing]
	,[plnnLIPBatchNo]
	,[plnnPlaintiffRole]
	,[plnnPlaintiffGroup]
	,[plnnPrimaryContact]
	)
select casnCaseID as [plnnCaseID]
	,1 as [plnnContactCtg]
	,(
		select cinncontactid
		from sma_MST_IndvContacts
		where cinsFirstName = 'Plaintiff'
			and cinsLastName = 'Unidentified'
		) as [plnnContactID]
	,-- Unidentified Plaintiff
	null as [plnnAddressID]
	,(
		select sbrnSubRoleId
		from sma_MST_SubRole S
		inner join sma_MST_SubRoleCode C
			on C.srcnCodeId = S.sbrnTypeCode
				and C.srcsDscrptn = '(P)-Default Role'
		where S.sbrnCaseTypeID = CAS.casnOrgCaseTypeID
		) as plnnRole
	,1 as [plnbIsPrimary]
	,0
	,0
	,0
	,0
	,0
	,0
	,null
	,null
	,null
	,null
	,null
	,null
	,GETDATE()
	,null
	,368 as [plnnRecUserID]
	,GETDATE() as [plndDtCreated]
	,null
	,null
	,''
	,null
	,''
	,null
	,null
	,null
	,null
	,null
	,1 as [plnnPrimaryContact]
from sma_trn_cases CAS
left join [sma_TRN_Plaintiff] T
	on T.plnnCaseID = CAS.casnCaseID
where plnnCaseID is null
go



UPDATE sma_TRN_Plaintiff set plnbIsPrimary=0

UPDATE sma_TRN_Plaintiff set plnbIsPrimary=1
FROM
(
SELECT DISTINCT 
	   T.plnnCaseID, ROW_NUMBER() OVER (Partition BY T.plnnCaseID order by P.record_num) as RowNumber,
	   T.plnnPlaintiffID as ID  
    FROM sma_TRN_Plaintiff T
    LEFT JOIN NeedlesKMY.[dbo].[party_indexed] P on P.TableIndex=T.saga_party
) A
WHERE A.RowNumber=1
and plnnPlaintiffID = A.ID



/*
-------------------------------------------------------------------------------
##############################################################################
-------------------------------------------------------------------------------
---(Appendix B)-- every case need at least one defendant
*/

insert into [sma_TRN_Defendants] (
	[defnCaseID]
	,[defnContactCtgID]
	,[defnContactID]
	,[defnAddressID]
	,[defnSubRole]
	,[defbIsPrimary]
	,[defbCounterClaim]
	,[defbThirdParty]
	,[defsThirdPartyRole]
	,[defnPriority]
	,[defdFrmDt]
	,[defdToDt]
	,[defnRecUserID]
	,[defdDtCreated]
	,[defnModifyUserID]
	,[defdDtModified]
	,[defnLevelNo]
	,[defsMarked]
	,[saga]
	)
select casnCaseID as [defnCaseID]
	,1 as [defnContactCtgID]
	,(
		select cinncontactid
		from sma_MST_IndvContacts
		where cinsFirstName = 'Defendant'
			and cinsLastName = 'Unidentified'
		) as [defnContactID]
	,null as [defnAddressID]
	,(
		select sbrnSubRoleId
		from sma_MST_SubRole S
		inner join sma_MST_SubRoleCode C
			on C.srcnCodeId = S.sbrnTypeCode
				and C.srcsDscrptn = '(D)-Default Role'
		where S.sbrnCaseTypeID = CAS.casnOrgCaseTypeID
		) as [defnSubRole]
	,1 as [defbIsPrimary]
	,-- reexamine??
	null
	,null
	,null
	,null
	,null
	,null
	,368 as [defnRecUserID]
	,GETDATE() as [defdDtCreated]
	,368 as [defnModifyUserID]
	,GETDATE() as [defdDtModified]
	,null
	,null
	,null
from sma_trn_cases CAS
left join [sma_TRN_Defendants] D
	on D.defnCaseID = CAS.casnCaseID
where D.defnCaseID is null

----
UPDATE sma_TRN_Defendants SET defbIsPrimary=0

UPDATE sma_TRN_Defendants SET defbIsPrimary=1
FROM (
    SELECT DISTINCT 
		D.defnCaseID, 
		ROW_NUMBER() OVER (Partition BY D.defnCaseID order by P.record_num) as RowNumber,
		D.defnDefendentID as ID  
    FROM sma_TRN_Defendants D
    LEFT JOIN NeedlesKMY.[dbo].[party_indexed] P on P.TableIndex=D.saga_party
) A
WHERE A.RowNumber=1
and defnDefendentID = A.ID

GO

---
ALTER TABLE [sma_TRN_Defendants] ENABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Plaintiff] ENABLE TRIGGER ALL
GO
