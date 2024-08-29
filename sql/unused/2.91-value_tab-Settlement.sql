
use [SA]
GO

/* ##############################################
Store applicable value codes
*/
DECLARE @NegSetValueCodes TABLE (code VARCHAR(10));

INSERT INTO @NegSetValueCodes (code)
VALUES
('MP'), ('PTC'), ('SET')

/*
alter table [sma_TRN_Settlements] disable trigger all
delete [sma_TRN_Settlements]
DBCC CHECKIDENT ('[sma_TRN_Settlements]', RESEED, 1);
alter table [sma_TRN_Settlements] enable trigger all
*/

--select distinct code, description from [NeedlesSLF].[dbo].[value] order by code
---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Settlements'))
begin
    ALTER TABLE [sma_TRN_Settlements] ADD [saga] int NULL; 
end
GO

---(0)---
------------------------------------------------
--INSERT SETTLEMENT TYPES
------------------------------------------------
INSERT INTO [sma_MST_SettlementType] (SettlTypeName)
SELECT 'Settlement'
UNION SELECT 'MedPay'
UNION SELECT 'Retainer Fee'
EXCEPT SELECT SettlTypeName FROM [sma_MST_SettlementType]
GO


---(0)---
if exists (select * from sys.objects where name='value_tab_Settlement_Helper' and type='U')
begin
	drop table value_tab_Settlement_Helper
end 
GO

---(0)---
create table value_tab_Settlement_Helper (
    TableIndex [int] IDENTITY(1,1) NOT NULL,
    case_id		    int,
    value_id		int,
    ProviderNameId	int,
    ProviderName	varchar(200),
    ProviderCID	    int,
    ProviderCTG	    int,
    ProviderAID	    int,
    casnCaseID		int,
    PlaintiffID	    int,
CONSTRAINT IOC_Clustered_Index_value_tab_Settlement_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Settlement_Helper_case_id ON [value_tab_Settlement_Helper] (case_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Settlement_Helper_value_id ON [value_tab_Settlement_Helper] (value_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Settlement_Helper_ProviderNameId ON [value_tab_Settlement_Helper] (ProviderNameId);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Settlement_Helper_PlaintiffID ON [value_tab_Settlement_Helper] (PlaintiffID);   
GO

---(0)---
insert into value_tab_Settlement_Helper ( case_id,value_id,ProviderNameId,ProviderName,ProviderCID,ProviderCTG,ProviderAID,casnCaseID,PlaintiffID )
select
    V.case_id		as case_id,	-- needles case
    V.value_id		as tab_id,		-- needles records TAB item
    V.provider		as ProviderNameId,  
    IOC.Name		as ProviderName,
    IOC.CID		    as ProviderCID,  
    IOC.CTG		    as ProviderCTG,
    IOC.AID		    as ProviderAID,
    CAS.casnCaseID	as casnCaseID,
    null			as PlaintiffID
from [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
JOIN IndvOrgContacts_Indexed IOC on IOC.SAGA = V.provider and isnull(V.provider,0) <> 0
where code in (SELECT code FROM NegSetValueCodes);
GO
---(0)---
DBCC DBREINDEX('value_tab_Settlement_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---(0)--- (prepare for multiple party)
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

select 
    V.case_id		    as cid,	
    V.value_id		    as vid,
    T.plnnPlaintiffID
INTO value_tab_Multi_Party_Helper_Temp   
FROM [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA = V.party_id
JOIN [sma_TRN_Plaintiff] T on T.plnnContactID=IOC.CID and T.plnnContactCtg=IOC.CTG and T.plnnCaseID=CAS.casnCaseID
GO

update value_tab_Settlement_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO


if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

select 
    V.case_id		    as cid,	
    V.value_id		    as vid,
    ( select plnnPlaintiffID from [sma_TRN_Plaintiff] where plnnCaseID=CAS.casnCaseID and plnbIsPrimary=1) as plnnPlaintiffID 
    into value_tab_Multi_Party_Helper_Temp   
from [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA = V.party_id
JOIN [sma_TRN_Defendants] D on D.defnContactID=IOC.CID and D.defnContactCtgID=IOC.CTG and D.defnCaseID=CAS.casnCaseID
GO

update value_tab_Settlement_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO

----(1)----(  specified items go to settlement rows )
alter table [sma_TRN_Settlements] disable trigger all
GO

insert into [sma_TRN_Settlements]
(
    stlnCaseID,
    stlnSetAmt,
    stlnNet,
    stlnNetToClientAmt,
    stlnPlaintiffID,
    stlnStaffID, 
    stlnLessDisbursement,
    stlnGrossAttorneyFee,
	stlnForwarder,  --referrer
	stlnOther,
	InterestOnDisbursement,
    stlsComments,
    stlTypeID,
	stldSettlementDate,
	saga
)
select 
    MAP.casnCaseID					as stlnCaseID,
    case when V.code IN ( 'MDP', 'RET', 'SET') then V.total_value
	   else null end				as stlnSetAmt,
    null							as stlnNet,
    null							as stlnNetToClientAmt, 
    MAP.PlaintiffID					as stlnPlaintiffID,
    null							as stlnStaffID, 
    null							as stlnLessDisbursement,
    case when V.code IN ('FEE') then V.total_value
	   else null end				as stlnGrossAttorneyFee,
	NULL							as stlnForwarder,    --Referrer
	case when v.code in ('CD') then v.total_value 
		else null end				as stlnOther,
    null							as InterestOnDisbursement,
    isnull('memo:' + nullif(V.memo,'') + CHAR(13),'') +
    isnull('code:' + nullif(V.code,'') + CHAR(13),'') +
	''								as [stlsComments],
    (select ID from [sma_MST_SettlementType] where SettlTypeName= case when v.[code] in ('CD', 'FEE','SET') then 'Settlement' 
																			when v.[code] in ('MDP') then 'MedPay'
																			when v.[code] in ('RET' ) then 'Retainer Fee' end ) 
									as stlTypeID,
    case when V.[start_date] between '1900-01-01' and '2079-06-06' then V.[start_date]
	   else null end				as stldSettlementDate,
    V.value_id						as saga
FROM [NeedlesSLF].[dbo].[value_Indexed] V
JOIN value_tab_Settlement_Helper MAP on MAP.case_id=V.case_id and MAP.value_id=V.value_id
WHERE V.code in  ( 'CD', 'FEE', 'MDP', 'RET', 'SET' )
GO
alter table [sma_TRN_Settlements] enable trigger all
GO

--Insert settlement checks - how to decide which settlement id to place the settlement check?
/*
insert into [SA].[dbo].[sma_TRN_CheckReceivedFeeRecorded] 
(			[crfnSettlementID]
           ,[crfnAmount]
           ,[crfdReceivedDate]
           ,[crfsTypeOfAmount]
           ,[crfsCheckNumber]
           ,[crfnTypeID]
           ,[StatusID]
           ,[CheckDate]
           ,[CheckMailedDate]
           ,[CheckDepositedDate]
           ,[CheckReceivedDate]
           ,[CheckExpirationDate]
           ,[UniquePayeeID]
           ,[CustomQBPayee]
           ,[Comments]
           ,[CreateDate]
           ,[CreateUserID]
           ,[ModifyDate]
           ,[ModifyUserID]
           ,[QBId]
           ,[QBExpLineId]
           ,[LastQBUpdateTime]
           ,[QBFailedTime]
           ,[ExpenseAccountId]
)

SELECT 
FROM [NeedlesSLF].[dbo].[value_Indexed] V
inner join value_tab_Settlement_Helper MAP on MAP.case_id=V.case_id and MAP.value_id=V.value_id
where V.code in  ( 'LOAN INTER','VA REIMBUR' )
*/











