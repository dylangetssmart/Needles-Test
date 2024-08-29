
-- use [SA]
-- GO

/* ##############################################
Create temporary table to hold disbursement value codes
*/
IF OBJECT_ID('tempdb..#DisbursementValueCodes') IS NOT NULL
    DROP TABLE #DisbursementValueCodes;

CREATE TABLE #DisbursementValueCodes (
    code VARCHAR(10)
);

INSERT INTO #DisbursementValueCodes (code)
VALUES
('CAD'), ('CEX'), ('CPY'), ('DTF'), ('EXP'), ('FUT MED'), ('PHO'), ('PST'), 
('PTF'), ('PTG'), ('PTP'), ('RPT'), ('TEL');

/*
alter table [sma_TRN_Disbursement] disable trigger all
delete from [sma_TRN_Disbursement] 
DBCC CHECKIDENT ('[sma_TRN_Disbursement]', RESEED, 0);
alter table [sma_TRN_Disbursement] enable trigger all
*/


/* ##############################################
Add saga to sma_TRN_Disbursement
*/
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Disbursement'))
begin
    ALTER TABLE [sma_TRN_Disbursement] ADD [saga] int NULL; 
end

-- Use this to create custom CheckRequestStatuses
    -- INSERT INTO [sma_MST_CheckRequestStatus] ([description])
    -- select 'Unrecouped'
    -- EXCEPT SELECT [description] FROM [sma_MST_CheckRequestStatus]


/* ##############################################
Create disbursement types for applicable value codes
*/
INSERT INTO [sma_MST_DisbursmentType]
(
    disnTypeCode
    ,dissTypeName
)
(
	SELECT DISTINCT
    'CONVERSION'
    ,VC.[description]
	FROM [NeedlesSLF].[dbo].[value] V
	    JOIN [NeedlesSLF].[dbo].[value_code] VC
            on VC.code=V.code 
	WHERE isnull(V.code,'') in (SELECT code FROM #DisbursementValueCodes)
)
EXCEPT 
SELECT 
    'CONVERSION'
    ,dissTypeName
FROM [sma_MST_DisbursmentType] 


/* ##############################################
Create Disbursement helper table
*/
if exists (select * from sys.objects where name='value_tab_Disbursement_Helper' and type='U')
begin
	drop table value_tab_Disbursement_Helper
end 
GO

create table value_tab_Disbursement_Helper (
    TableIndex [int] IDENTITY(1,1) NOT NULL,
    case_id		    int,
    value_id		int,
    ProviderNameId	int,
    ProviderName	varchar(200),
    ProviderCID	    int,
    ProviderCTG	    int,
    ProviderAID	    int,
    ProviderUID	    bigint,
    casnCaseID		int,
    PlaintiffID	    int,
CONSTRAINT IOC_Clustered_Index_value_tab_Disbursement_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Disbursement_Helper_case_id ON [value_tab_Disbursement_Helper] (case_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Disbursement_Helper_value_id ON [value_tab_Disbursement_Helper] (value_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_Disbursement_Helper_ProviderNameId ON [value_tab_Disbursement_Helper] (ProviderNameId);   
GO

---(0)---
insert into value_tab_Disbursement_Helper
(
    case_id
    ,value_id
    ,ProviderNameId
    ,ProviderName
    ,ProviderCID
    ,ProviderCTG
    ,ProviderAID
    ,ProviderUID
    ,casnCaseID
    ,PlaintiffID
)
select
    V.case_id		    as case_id,	        -- needles case
    V.value_id		    as tab_id,		    -- needles records TAB item
    V.provider		    as ProviderNameId,  
    IOC.Name		    as ProviderName,
    IOC.CID				as ProviderCID,  
    IOC.CTG				as ProviderCTG,
    IOC.AID				as ProviderAID,
    IOC.UNQCID		    as ProviderUID,
    CAS.casnCaseID	    as casnCaseID,
    null			    as PlaintiffID
from [NeedlesSLF].[dbo].[value_Indexed] V
JOIN [sma_TRN_cases] CAS
    on CAS.cassCaseNumber = V.case_id
JOIN IndvOrgContacts_Indexed IOC
    on IOC.SAGA = V.provider and isnull(V.provider,0) <> 0
where code in (SELECT code FROM #DisbursementValueCodes);
GO

---(0)---
DBCC DBREINDEX('value_tab_Disbursement_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---(0)--- value_id may associate with secondary plaintiff
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

SELECT 
    V.case_id		    as cid
    ,V.value_id		    as vid
    ,T.plnnPlaintiffID
INTO value_tab_Multi_Party_Helper_Temp   
FROM [NeedlesSLF].[dbo].[value_Indexed] V
    JOIN [sma_TRN_cases] CAS
        on CAS.cassCaseNumber = V.case_id
    JOIN IndvOrgContacts_Indexed IOC
        on IOC.SAGA = V.party_id
    JOIN [sma_TRN_Plaintiff] T
        on T.plnnContactID=IOC.CID
        and T.plnnContactCtg=IOC.CTG
        and T.plnnCaseID=CAS.casnCaseID

update value_tab_Disbursement_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO

---(0)--- value_id may associate with defendant. steve malman make it associates to primary plaintiff 
if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
begin
    drop table value_tab_Multi_Party_Helper_Temp
end
GO

SELECT 
    V.case_id		    as cid
    ,V.value_id		    as vid
    ,(
        select plnnPlaintiffID
        from sma_TRN_Plaintiff
        where plnnCaseID = CAS.casnCaseID and plnbIsPrimary = 1
    )                   as plnnPlaintiffID 
into value_tab_Multi_Party_Helper_Temp
FROM [NeedlesSLF].[dbo].[value_Indexed] V
    JOIN [sma_TRN_cases] CAS
        on CAS.cassCaseNumber = V.case_id
    JOIN [IndvOrgContacts_Indexed] IOC
        on IOC.SAGA = V.party_id
    JOIN [sma_TRN_Defendants] D
        on D.defnContactID=IOC.CID
        and D.defnContactCtgID=IOC.CTG
        and D.defnCaseID=CAS.casnCaseID
GO

update value_tab_Disbursement_Helper set PlaintiffID=A.plnnPlaintiffID
from value_tab_Multi_Party_Helper_Temp A
where case_id=A.cid and value_id=A.vid
GO


/* ##############################################
Create Disbursements
*/
alter table [sma_TRN_Disbursement] disable trigger all
GO

INSERT INTO [sma_TRN_Disbursement]
(
    disnCaseID,
    disdCheckDt,
    disnPayeeContactCtgID,
    disnPayeeContactID,
    disnAmount,
    disnPlaintiffID,
    dissDisbursementType,
    UniquePayeeID,
    dissDescription,
    dissComments,
    disnCheckRequestStatus,
    disdBillDate,
    disdDueDate,
    disnRecUserID,
    disdDtCreated,
    disnRecoverable,
    saga
)
select 
    MAP.casnCaseID		                    as disnCaseID
    ,u.Check_Requested                        as disdCheckDt
    ,MAP.ProviderCTG	                    as disnPayeeContactCtgID
    ,MAP.ProviderCID	                    as disnPayeeContactID
    ,V.total_value		                    as disnAmount
    ,MAP.PlaintiffID 	                    as disnPlaintiffID
    ,(
        select disnTypeID
        from [sma_MST_DisbursmentType]
        where dissTypeName = (
                                select [description]
                                FROM [NeedlesSLF].[dbo].[value_code]
                                where [code]=V.code
                            )
    )                                       as dissDisbursementType
    ,MAP.ProviderUID	                    as UniquePayeeID
    ,V.[memo]                               as dissDescription
    ,v.settlement_memo + 
    ISNULL('Account Number: ' + NULLIF(CAST(Account_Number AS VARCHAR(MAX)), '') + CHAR(13), '') +
    ISNULL('Cancel: ' + NULLIF(CAST(Cancel AS VARCHAR(MAX)), '') + CHAR(13), '') +    
    ISNULL('CM Reviewed: ' + NULLIF(CAST(CM_Reviewed AS VARCHAR(MAX)), '') + CHAR(13), '') +
    ISNULL('Date Paid: ' + NULLIF(CAST(Date_Paid AS VARCHAR(MAX)), '') + CHAR(13), '') +
    ISNULL('For Dates From: ' + NULLIF(CAST(For_Dates_From AS VARCHAR(MAX)), '') + CHAR(13), '') +
    ISNULL('OI Checked: ' + NULLIF(CAST(OI_Checked AS VARCHAR(MAX)), '') + CHAR(13), '')
                                            as dissComments
    ,case
        -- when v.code in ('CEX', 'CSF', 'ICF', 'MCF' )
        --     then (
        --             select Id
        --             FROM [sma_MST_CheckRequestStatus]
        --             where [Description]='Paid'
        --         )
		-- when v.code in ('UCC')
        --     then (
        --             select Id
        --             FROM [sma_MST_CheckRequestStatus]
        --             where [Description]='Check Pending'
        --         )
        when isnull(Check_Requested,'') <> ''
            then (
                select Id
                FROM [sma_MST_CheckRequestStatus]
                where [Description]='Check Pending'
            )
		else NULL
        end	                                as disnCheckRequestStatus
    ,case
        when V.start_date between '1900-01-01' and '2079-06-06'
            then V.start_date
        else null 
        end	                                as disdBillDate
    ,case
        when V.stop_date between '1900-01-01' and '2079-06-06'
            then V.stop_date
	   else null
       end	                                as disdDueDate
    ,(
        select usrnUserID
        from sma_MST_Users
        where saga=V.staff_created
    )                                       as disnRecUserID
    ,case
        when date_created between '1900-01-01' and '2079-06-06'
            then date_created
	   else null
       end	                                as disdDtCreated
	,case
        when v.code = 'DTF'
            then 0 
        else 1 
        end		                            as disnRecoverable
    ,V.value_id			                    as saga
FROM [NeedlesSLF].[dbo].[value_Indexed] V
JOIN value_tab_Disbursement_Helper MAP
    on MAP.case_id = V.case_id 
    and MAP.value_id = V.value_id
join NeedlesSLF..user_tab2_data u
    on u.case_id = v.case_id
GO
---
alter table [sma_TRN_Disbursement] enable trigger all
GO
---

