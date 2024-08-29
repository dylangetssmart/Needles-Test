
-- use [SANeedlesSLF]
GO

/* ##############################################
Store applicable value codes
*/
CREATE TABLE #LienValueCodes (code VARCHAR(10));

INSERT INTO #LienValueCodes (code)
VALUES
('LIEN'), ('LIEN WC');



/*
alter table [SANeedlesSLF].[dbo].[sma_TRN_Lienors] disable trigger all
delete from [SANeedlesSLF].[dbo].[sma_TRN_Lienors] 
DBCC CHECKIDENT ('[SANeedlesSLF].[dbo].[sma_TRN_Lienors]', RESEED, 0);
alter table [SANeedlesSLF].[dbo].[sma_TRN_Lienors] enable trigger all

alter table [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] disable trigger all
delete from [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] 
DBCC CHECKIDENT ('[SANeedlesSLF].[dbo].[sma_TRN_LienDetails]', RESEED, 0);
alter table [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] enable trigger all


alter table [SANeedlesSLF].[dbo].[sma_TRN_Lienors] disable trigger all

alter table [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] disable trigger all


select count(*) from [SANeedlesSLF].[dbo].[sma_TRN_Lienors]

select * from value_tab_Liencheckbox_Helper 

select * from [NeedlesSLF].[dbo].[value_payment] where value_id=65990

*/



---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Lienors'))
begin
    ALTER TABLE [sma_TRN_Lienors] ADD [saga] int NULL; 
end

---(0)---
if exists (select * from sys.objects where name='value_tab_Liencheckbox_Helper' and type='U')
begin
	drop table value_tab_Liencheckbox_Helper
end 
GO

---(0)---
create table value_tab_Liencheckbox_Helper (
    TableIndex		    int IDENTITY(1,1) NOT NULL,
    value_id		    int,
CONSTRAINT IOC_Clustered_Index_value_tab_Liencheckbox_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Liencheckbox_Helper_value_id ON [SANeedlesSLF].[dbo].[value_tab_Liencheckbox_Helper] (value_id);   
GO

---(0)---
insert into value_tab_Liencheckbox_Helper
(
    value_id 
)
select VP1.value_id
from [NeedlesSLF].[dbo].[value_payment] VP1 
    left join (
                select distinct value_id
                from [NeedlesSLF].[dbo].[value_payment]
                where lien='Y'
                ) VP2 
        on VP1.value_id = VP2.value_id
        and VP2.value_id is not null
where VP2.value_id is not null -- ( Lien checkbox got marked ) 
GO

---(0)---
DBCC DBREINDEX('value_tab_Liencheckbox_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---(0)---
insert into [SANeedlesSLF].[dbo].[sma_MST_LienType]
(
    [lntsCode]
    ,[lntsDscrptn]
)
(
    select distinct 'CONVERSION',VC.[description]
    from [NeedlesSLF].[dbo].[value] V
    inner join [NeedlesSLF].[dbo].[value_code] VC
        on VC.code = V.code 
    where isnull(V.code,'') in (SELECT code FROM #LienValueCodes)
)
except
select [lntsCode],[lntsDscrptn] from [SANeedlesSLF].[dbo].[sma_MST_LienType] 
GO


---(0)---
if exists (select * from sys.objects where name='value_tab_Lien_Helper' and type='U')
begin
	drop table value_tab_Lien_Helper
end 
GO

---(0)---
create table value_tab_Lien_Helper (
    TableIndex [int] IDENTITY(1,1) NOT NULL,
    case_id		    int,
    value_id		    int,
    ProviderNameId	    int,
    ProviderName	    varchar(200),
    ProviderCID	    int,
    ProviderCTG	    int,
    ProviderAID	    int,
    casnCaseID		    int,
    PlaintiffID	    int,
    Paid			    varchar(20),
CONSTRAINT IOC_Clustered_Index_value_tab_Lien_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Lien_Helper_case_id ON [SANeedlesSLF].[dbo].[value_tab_Lien_Helper] (case_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Lien_Helper_value_id ON [SANeedlesSLF].[dbo].[value_tab_Lien_Helper] (value_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Lien_Helper_ProviderNameId ON [SANeedlesSLF].[dbo].[value_tab_Lien_Helper] (ProviderNameId);   
GO

---(0)---
insert into value_tab_Lien_Helper ( case_id,value_id,ProviderNameId,ProviderName,ProviderCID,ProviderCTG,ProviderAID,casnCaseID,PlaintiffID,Paid )
select
    V.case_id		    as case_id,	-- needles case
    V.value_id		    as tab_id,		-- needles records TAB item
    V.provider		    as ProviderNameId,  
    IOC.Name		    as ProviderName,
    IOC.CID		        as ProviderCID,  
    IOC.CTG		        as ProviderCTG,
    IOC.AID		        as ProviderAID,
    CAS.casnCaseID	    as casnCaseID,
    null			    as PlaintiffID,
    null			    as Paid
from [NeedlesSLF].[dbo].[value_Indexed] V
inner join [SANeedlesSLF].[dbo].[sma_TRN_cases] CAS
    on CAS.cassCaseNumber = V.case_id
inner join [SANeedlesSLF].[dbo].[IndvOrgContacts_Indexed] IOC
    on IOC.SAGA = V.provider
    and isnull(V.provider,0)<>0
where code in (SELECT code FROM #LienValueCodes)
OR V.value_id in ( select value_id from value_tab_Liencheckbox_Helper ) 

GO
---(0)---
DBCC DBREINDEX('value_tab_Lien_Helper',' ',90)  WITH NO_INFOMSGS 
GO



---(0)---
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

select 
    V.case_id		    as cid,	
    V.value_id		    as vid,
    convert(varchar,((select sum(payment_amount) from [NeedlesSLF].[dbo].[value_payment] where value_id=V.value_id))) as Paid,
    T.plnnPlaintiffID
    into value_tab_Multi_Party_Helper_Temp   
from [NeedlesSLF].[dbo].[value_Indexed] V
inner join [SANeedlesSLF].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
inner join [SANeedlesSLF].[dbo].[IndvOrgContacts_Indexed] IOC on IOC.SAGA = V.party_id
inner join [SANeedlesSLF].[dbo].[sma_TRN_Plaintiff] T on T.plnnContactID=IOC.CID and T.plnnContactCtg=IOC.CTG and T.plnnCaseID=CAS.casnCaseID
GO

update value_tab_Lien_Helper set PlaintiffID=A.plnnPlaintiffID,Paid=A.Paid
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
    convert(varchar,((select sum(payment_amount) from [NeedlesSLF].[dbo].[value_payment] where value_id=V.value_id))) as Paid,
    ( select plnnPlaintiffID from [SANeedlesSLF].[dbo].[sma_TRN_Plaintiff] where plnnCaseID=CAS.casnCaseID and plnbIsPrimary=1) as plnnPlaintiffID 
    into value_tab_Multi_Party_Helper_Temp   
from [NeedlesSLF].[dbo].[value_Indexed] V
inner join [SANeedlesSLF].[dbo].[sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
inner join [SANeedlesSLF].[dbo].[IndvOrgContacts_Indexed] IOC on IOC.SAGA = V.party_id
inner join [SANeedlesSLF].[dbo].[sma_TRN_Defendants] D on D.defnContactID=IOC.CID and D.defnContactCtgID=IOC.CTG and D.defnCaseID=CAS.casnCaseID
GO

update value_tab_Lien_Helper set PlaintiffID=A.plnnPlaintiffID,Paid=A.Paid
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO


---------------------------------------------------------------------------------------
alter table [SANeedlesSLF].[dbo].[sma_TRN_Lienors] disable trigger all
alter table [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] disable trigger all

GO
---(1)---
insert into [SANeedlesSLF].[dbo].[sma_TRN_Lienors]
(
    [lnrnCaseID],
    [lnrnLienorTypeID],
    [lnrnLienorContactCtgID],
    [lnrnLienorContactID],
    [lnrnLienorAddressID],
    [lnrnLienorRelaContactID],
    [lnrnPlaintiffID],
    [lnrnCnfrmdLienAmount],
    [lnrnNegLienAmount],
    [lnrsComments],
    [lnrnRecUserID],
    [lnrdDtCreated],
    [lnrnFinal],
    [saga]
)

  select 
    MAP.casnCaseID			  as [lnrnCaseID],
    ( select top 1 lntnLienTypeID FROM [SANeedlesSLF].[dbo].[sma_MST_LienType] where lntsDscrptn=
	   (select [description] FROM [NeedlesSLF].[dbo].[value_code] where [code]=V.code)) 
						  as [lnrnLienorTypeID],				   
    MAP.ProviderCTG			  as [lnrnLienorContactCtgID],
    MAP.ProviderCID			  as [lnrnLienorContactID],
    MAP.ProviderAID			  as [lnrnLienorAddressID],
    0					  as [lnrnLienorRelaContactID],
    MAP.PlaintiffID			  as [lnrnPlaintiffID],
    isnull(V.total_value,0)	  as [lnrnCnfrmdLienAmount],
    isnull(V.due,0)			  as [lnrnNegLienAmount],
    isnull('Memo : ' + isnull(V.memo,'') + CHAR(13),'') +
    isnull('From : ' + convert(varchar(10),V.start_date) + CHAR(13),'') +
    isnull('To : ' + convert(varchar(10),V.stop_date) + CHAR(13),'') + 
    isnull('Value Total : ' + convert(varchar,V.total_value) + CHAR(13),'') +
    isnull('Reduction : ' + convert(varchar,V.reduction) + CHAR(13),'') +
    isnull('Paid : ' + MAP.Paid,'') 
						  as [lnrsComments],
    368					  as [lnrnRecUserID],
    getdate()				  as [lnrdDtCreated],
    0					  as [lnrnFinal],
    V.value_id				  as [saga]
from [NeedlesSLF].[dbo].[value_Indexed] V
inner join [SANeedlesSLF].[dbo].[value_tab_Lien_Helper] MAP on MAP.case_id=V.case_id and MAP.value_id=V.value_id

---(2)---
insert into [SANeedlesSLF].[dbo].[sma_TRN_LienDetails]
(
	lndnLienorID,
	lndnLienTypeID,
	lndnCnfrmdLienAmount,
	lndsRefTable,
	lndnRecUserID,
	lnddDtCreated
)
select 
	lnrnLienorID			as lndnLienorID, --> same as lndnRecordID
	lnrnLienorTypeID		as lndnLienTypeID,
	lnrnCnfrmdLienAmount	as lndnCnfrmdLienAmount,
	'sma_TRN_Lienors'		as lndsRefTable,
	368					as lndnRecUserID,
	getdate()				as lnddDtCreated
from [SANeedlesSLF].[dbo].[sma_TRN_Lienors]


----
alter table [SANeedlesSLF].[dbo].[sma_TRN_Lienors] enable trigger all
alter table [SANeedlesSLF].[dbo].[sma_TRN_LienDetails] enable trigger all

GO





