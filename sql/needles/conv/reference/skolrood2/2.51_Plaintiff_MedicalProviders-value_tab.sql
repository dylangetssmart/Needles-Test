
-- use [SA]
-- GO
/*
alter table [sma_TRN_Hospitals] disable trigger all
delete [sma_TRN_Hospitals]
DBCC CHECKIDENT ('[sma_TRN_Hospitals]', RESEED, 0);
alter table [sma_TRN_Hospitals] enable trigger all

alter table [sma_TRN_SpDamages] disable trigger all
delete [sma_TRN_SpDamages]
DBCC CHECKIDENT ('[sma_TRN_SpDamages]', RESEED, 0);
alter table [sma_TRN_SpDamages] enable trigger all

alter table [sma_TRN_SpecialDamageAmountPaid] disable trigger all
delete [sma_TRN_SpecialDamageAmountPaid]
DBCC CHECKIDENT ('[sma_TRN_SpecialDamageAmountPaid]', RESEED, 0);
alter table [sma_TRN_SpecialDamageAmountPaid] enable trigger all
*/


/* ##############################################
Create temporary table to hold disbursement value codes
*/
IF OBJECT_ID('tempdb..#MedChargeCodes') IS NOT NULL
    DROP TABLE #MedChargeCodes;

CREATE TABLE #MedChargeCodes (
    code VARCHAR(10)
);

INSERT INTO #MedChargeCodes (code)
VALUES
('MED')


alter table [sma_TRN_Hospitals] disable trigger all
GO
alter table [sma_TRN_SpDamages] disable trigger all
GO
alter table [sma_TRN_SpecialDamageAmountPaid] disable trigger all
GO


---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Hospitals'))
begin
    ALTER TABLE [sma_TRN_Hospitals] ADD [saga] [varchar](100) NULL; 
end
GO

---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga_bill_id' AND Object_ID = Object_ID(N'sma_TRN_SpDamages'))
begin
    ALTER TABLE [sma_TRN_SpDamages] ADD [saga_bill_id] [varchar](100) NULL; 
end
GO

---(0)---
if exists (select * from sys.objects where name='value_tab_MedicalProvider_Helper' and type='U')
begin
	drop table value_tab_MedicalProvider_Helper
end 
GO

---(0)---
create table value_tab_MedicalProvider_Helper (
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
CONSTRAINT IOC_Clustered_Index_value_tab_MedicalProvider_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_MedicalProvider_Helper_case_id ON [value_tab_MedicalProvider_Helper] (case_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_MedicalProvider_Helper_value_id ON [value_tab_MedicalProvider_Helper] (value_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_MedicalProvider_Helper_ProviderNameId ON [value_tab_MedicalProvider_Helper] (ProviderNameId);   
GO

---(0)---
INSERT INTO value_tab_MedicalProvider_Helper ( case_id,value_id,ProviderNameId,ProviderName,ProviderCID,ProviderCTG,ProviderAID,casnCaseID,PlaintiffID )
SELECT
    V.case_id		as case_id,	-- needles case
    V.value_id		as tab_id,		-- needles records TAB item
    V.provider		as ProviderNameId,  
    IOC.Name		as ProviderName,
    IOC.CID		    as ProviderCID,  
    IOC.CTG		    as ProviderCTG,
    IOC.AID		    as ProviderAID,
    CAS.casnCaseID	as casnCaseID,
    null			as PlaintiffID
FROM [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS
    on CAS.cassCaseNumber = V.case_id
JOIN IndvOrgContacts_Indexed IOC
    on IOC.SAGA = V.provider
    and isnull(V.provider,0) <> 0
WHERE code in (SELECT code FROM #SpDmgValueCodes)
GO

---(0)---
DBCC DBREINDEX('value_tab_MedicalProvider_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---(0)--- value_id may associate with secondary plaintiff
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

SELECT 
    V.case_id		    as cid,	
    V.value_id		    as vid,
    T.plnnPlaintiffID
INTO value_tab_Multi_Party_Helper_Temp   
FROM [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
JOIN IndvOrgContacts_Indexed IOC on IOC.SAGA = V.party_id
JOIN [sma_TRN_Plaintiff] T on T.plnnContactID=IOC.CID and T.plnnContactCtg=IOC.CTG and T.plnnCaseID=CAS.casnCaseID

update value_tab_MedicalProvider_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO

---(0)--- value_id may associate with defendant. steve malman make it associates to primary plaintiff 
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

select 
    V.case_id		    as cid,	
    V.value_id		    as vid,
    ( select plnnPlaintiffID from [SA].[dbo].[sma_TRN_Plaintiff] where plnnCaseID=CAS.casnCaseID and plnbIsPrimary=1) as plnnPlaintiffID 
    into value_tab_Multi_Party_Helper_Temp   
from [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA = V.party_id
JOIN [sma_TRN_Defendants] D on D.defnContactID=IOC.CID and D.defnContactCtgID=IOC.CTG and D.defnCaseID=CAS.casnCaseID
GO

UPDATE value_tab_MedicalProvider_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO


---(1)---
insert into [sma_TRN_Hospitals]
(
    [hosnCaseID]
	,[hosnContactID]
	,[hosnContactCtg]
	,[hosnAddressID] 
	,[hossMedProType] 
	,[hosdStartDt]
	,[hosdEndDt]
	,[hosnPlaintiffID]
	,[hosnComments] 
	,[hosnHospitalChart] 
	,[hosnRecUserID]
	,[hosdDtCreated] 
	,[hosnModifyUserID]
	,[hosdDtModified]
	,[saga]
)
select 
    A.casnCaseID		   as [hosnCaseID]
    ,A.ProviderCID		   as [hosnContactID]
    ,A.ProviderCTG		   as [hosnContactCtg]
    ,A.ProviderAID		   as [hosnAddressID]
    ,'M'				   as [hossMedProType]
    ,null				   as [hosdStartDt]
    ,null				   as [hosdEndDt]
    ,A.PlaintiffID		   as hosnPlaintiffID
    ,null				   as [hosnComments]
    ,null				   as [hosnHospitalChart]
    ,368			       as [hosnRecUserID]
    ,getdate()			   as [hosdDtCreated]
    ,null				   as [hosnModifyUserID]
    ,null				   as [hosdDtModified]
    ,'value'		       as [saga]
from
(
select -- (Note: make sure no duplicate provider per case )
    ROW_NUMBER() over(partition by MAP.ProviderCID,MAP.ProviderCTG,MAP.casnCaseID,MAP.PlaintiffID order by V.value_id ) as RowNumber,
    MAP.PlaintiffID,
    MAP.casnCaseID,
    MAP.ProviderCID,
    MAP.ProviderCTG,
    MAP.ProviderAID
from [NeedlesSLF].[dbo].[value_Indexed] V
inner join value_tab_MedicalProvider_Helper MAP on MAP.case_id=V.case_id and MAP.value_id=V.value_id
) A where A.RowNumber=1 ---Note: No merging. got to be the first script to populate Medical Provider
GO

---(2)--- (Medical Provider Bill section)
insert into [sma_TRN_SpDamages]
(
    [spdsRefTable]
    ,[spdnRecordID]
    ,[spdnBillAmt]
    ,[spddNegotiatedBillAmt]
    ,[spddDateFrom]
    ,[spddDateTo]
    ,[spddDamageSubType]
    ,[spdnVisitId]
    ,[spdsComments]
    ,[spdnRecUserID]
    ,[spddDtCreated]
    ,[spdnModifyUserID]
    ,[spddDtModified]
    ,[spdnBalance]
    ,[spdbLienConfirmed]
    ,[spdbDocAttached]
    ,[saga_bill_id]
)
select 
    'Hospitals'                         as spdsRefTable
    ,H.hosnHospitalID                   as spdnRecordID
    ,V.total_value                      as spdnBillAmt
    ,(V.total_value - V.reduction)	    as spddNegotiatedBillAmt
    ,case
        when V.[start_date] between '1900-01-01' and '2079-06-06'
            then convert(date,V.[start_date])
        else NULL
        end                             as spddDateFrom
    ,case
        when V.[stop_date] between '1900-01-01' and '2079-06-06'
            then convert(date,V.[stop_date])
        else NULL
        end                             as spddDateTo
    ,null				                as spddDamageSubType
    ,null				                as spdnVisitId
    ,isnull('value tab medical bill. memo - '+ nullif(memo,''),'') as spdsComments
    ,368				                as spdnRecordID
    ,getdate()			                as spddDtCreated
    ,null				                as spdnModifyUserID
    ,null				                as spddDtModified
    ,V.due				                as spdnBalance
    ,0					                as spdbLienConfirmed
    ,0					                as spdbDocAttached
    ,V.value_id			                as saga_bill_id  -- one bill one value
from [NeedlesSLF].[dbo].[value_Indexed] V  
JOIN value_tab_MedicalProvider_Helper MAP
    on MAP.case_id = V.case_id
    and MAP.value_id = V.value_id
JOIN [sma_TRN_Hospitals] H
    on H.hosnContactID = MAP.ProviderCID
    and H.hosnContactCtg = MAP.ProviderCTG
    and H.hosnCaseID = MAP.casnCaseID
    and H.hosnPlaintiffID = MAP.PlaintiffID
GO

---(3)--- (Amount Paid section)  --Type=Client--
insert into [sma_TRN_SpecialDamageAmountPaid]
(
    [AmountPaidDamageReferenceID]
    ,[AmountPaidCollateralType]
    ,[AmountPaidPaidByID]
    ,[AmountPaidTotal]
    ,[AmountPaidClaimSubmittedDt]
    ,[AmountPaidDate]
    ,[AmountPaidRecUserID]
    ,[AmountPaidDtCreated]
    ,[AmountPaidModifyUserID]
    ,[AmountPaidDtModified]
    ,[AmountPaidLevelNo]
    ,[AmountPaidAdjustment]
    ,[AmountPaidComments]
)
select 
    SPD.spdnSpDamageID		as [AmountPaidDamageReferenceID]
    ,(
        select cltnCollateralTypeID
        from [dbo].[sma_MST_CollateralType]
        where cltsDscrptn = 'Client'
    )                       as [AmountPaidCollateralType]
	,null					as [AmountPaidPaidByID]
    ,VP.payment_amount      as [AmountPaidTotal]
    ,null					as [AmountPaidClaimSubmittedDt]
	,case
		when VP.date_paid between '1900-01-01' and '2079-06-06'
            then VP.date_paid
		else null			
	    end					as [AmountPaidDate]
    ,368					as [AmountPaidRecUserID]
    ,getdate()				as [AmountPaidDtCreated]
    ,null					as [AmountPaidModifyUserID]
    ,null					as [AmountPaidDtModified]
    ,null					as [AmountPaidLevelNo]
    ,null					as [AmountPaidAdjustment]
    ,isnull('paid by:' + nullif(VP.paid_by,'') + CHAR(13),'')
        + isnull('paid to:' + nullif(VP.paid_to,'') + CHAR(13),'')
        + ''				as [AmountPaidComments]
from [NeedlesSLF].[dbo].[value_Indexed] V
JOIN value_tab_MedicalProvider_Helper MAP
    on MAP.case_id = V.case_id
    and MAP.value_id = V.value_id
JOIN [sma_TRN_SpDamages] SPD
    on SPD.saga_bill_id = V.value_id
JOIN [NeedlesSLF].[dbo].[value_payment] VP
    on VP.value_id = V.value_id -- multiple payment per value_id
GO


---(Appendix)--- Update hospital TotalBill from Bill section
UPDATE [sma_TRN_Hospitals]
SET hosnTotalBill = (SELECT SUM(spdnBillAmt) FROM sma_TRN_SpDamages WHERE sma_TRN_SpDamages.spdsRefTable='Hospitals' AND sma_TRN_SpDamages.spdnRecordID = hosnHospitalID)
GO

-----------
alter table [sma_TRN_Hospitals] enable trigger all
GO
alter table [sma_TRN_SpDamages] enable trigger all
GO
alter table [sma_TRN_SpecialDamageAmountPaid] enable trigger all
GO
-----------





