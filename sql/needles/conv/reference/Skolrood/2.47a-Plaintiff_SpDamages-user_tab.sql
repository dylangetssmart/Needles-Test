
-- use SA
-- GO

/* ##############################################
Create temporary table to hold disbursement value codes
*/
-- IF OBJECT_ID('tempdb..#SpDmgValueCodes') IS NOT NULL
--     DROP TABLE ##SpDmgValueCodes;

-- CREATE TABLE ##SpDmgValueCodes (
--     code VARCHAR(10)
-- );

-- INSERT INTO #SpDmgValueCodes (code)
-- VALUES
-- ('MIL'), ('MISC LOSS'), ('PRO')


-- ----------------------------------------------------------------------------
-- --CUSTOM DAMAGE
-- ----------------------------------------------------------------------------
-- --delete From [sma_TRN_SpDamages] where spdsRefTable = 'CustomDamage'
-- --INSERT DAMAGE SUBTYPE (UNDER "OTHER" DAMAGE TYPE)
-- IF (
--     select count(*)
--     from sma_MST_SpecialDamageType
--     where SpDamageTypeDescription = 'Other'
--     ) = 0
-- BEGIN
-- INSERT INTO sma_MST_SpecialDamageType
-- (
--     SpDamageTypeDescription
--     ,IsEditableType
--     ,SpDamageTypeCreatedUserID
--     ,SpDamageTypeDtCreated
-- )
-- select
--     'Other'
--     ,1
--     ,368
--     ,getdate()
-- END


-- insert into sma_MST_SpecialDamageSubType
-- (
--     spdamagetypeid
--     ,SpDamageSubTypeDescription
--     ,SpDamageSubTypeDtCreated
--     ,SpDamageSubTypeCreatedUserID
-- )
-- select
--     (
--         select spdamagetypeid
--         from sma_MST_SpecialDamageType
--         where SpDamageTypeDescription = 'Other'
--     )
--     ,vc.[description]
--     ,getdate()
--     ,368
-- from NeedlesSLF..value_code vc
-- where code in (SELECT code FROM #SpDmgValueCodes)


-- ---(0)---
-- if exists (select * from sys.objects where name='value_tab_spDamages_Helper' and type='U')
-- begin
-- 	drop table value_tab_spDamages_Helper
-- end 
-- GO

-- ---(0)---
-- create table value_tab_spDamages_Helper (
--     TableIndex [int] IDENTITY(1,1) NOT NULL,
--     case_id		    int,
--     value_id		int,
--     ProviderNameId	int,
--     ProviderName	varchar(200),
--     ProviderCID	    int,
--     ProviderCTG	    int,
--     ProviderAID	    int,
--     casnCaseID		int,
--     PlaintiffID	    int,
-- CONSTRAINT IOC_Clustered_Index_value_tab_spDamages_Helper PRIMARY KEY CLUSTERED ( TableIndex )
-- ) ON [PRIMARY] 
-- GO

-- CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_spDamages_Helper_case_id ON [value_tab_spDamages_Helper] (case_id);   
-- CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_spDamages_Helper_value_id ON [value_tab_spDamages_Helper] (value_id);   
-- CREATE NONCLUSTERED INDEX IX_NonClustered_Index_value_tab_spDamages_Helper_ProviderNameId ON [value_tab_spDamages_Helper] (ProviderNameId);   
-- GO

-- ---(0)---
-- insert into [value_tab_spDamages_Helper]
-- (
--     case_id
--     ,value_id
--     ,ProviderNameId
--     ,ProviderName
--     ,ProviderCID
--     ,ProviderCTG
--     ,ProviderAID
--     ,casnCaseID
--     ,PlaintiffID
-- )
-- select
--     V.case_id		as case_id,	            -- needles case
--     V.value_id		as tab_id,		        -- needles records TAB item
--     V.provider		as ProviderNameId,  
--     IOC.Name		as ProviderName,
--     IOC.CID		    as ProviderCID,  
--     IOC.CTG		    as ProviderCTG,
--     IOC.AID		    as ProviderAID,
--     CAS.casnCaseID	as casnCaseID,
--     null			as PlaintiffID  
-- from [NeedlesSLF].[dbo].[value_Indexed] V
-- JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber = V.case_id
-- JOIN IndvOrgContacts_Indexed IOC on IOC.SAGA = V.provider and isnull(V.provider,0)<>0
-- where code in (SELECT code FROM #SpDmgValueCodes)

-- ---(0)---
-- DBCC DBREINDEX('value_tab_spDamages_Helper',' ',90)  WITH NO_INFOMSGS 
-- GO

-- ---(0)---
-- if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
-- begin
--     drop table value_tab_Multi_Party_Helper_Temp
-- end
-- GO

-- select 
--     V.case_id		    as cid,	
--     V.value_id		    as vid,
--     T.plnnPlaintiffID
--     into value_tab_Multi_Party_Helper_Temp   
-- from [NeedlesSLF].[dbo].[value_Indexed] V
-- JOIN [sma_TRN_cases] CAS
--     on CAS.cassCaseNumber = V.case_id
-- JOIN [IndvOrgContacts_Indexed] IOC
--     on IOC.SAGA = V.party_id
-- JOIN [sma_TRN_Plaintiff] T
--     on T.plnnContactID=IOC.CID
--     and T.plnnContactCtg=IOC.CTG
--     and T.plnnCaseID=CAS.casnCaseID
-- GO

-- update [value_tab_spDamages_Helper] set PlaintiffID=A.plnnPlaintiffID
-- from value_tab_Multi_Party_Helper_Temp A
-- where case_id=A.cid and value_id=A.vid
-- GO


-- if exists (select * from sys.objects where Name='value_tab_Multi_Party_Helper_Temp')
-- begin
--     drop table value_tab_Multi_Party_Helper_Temp
-- end
-- GO

-- select 
--     V.case_id		    as cid,	
--     V.value_id		    as vid,
--     (
--         select plnnPlaintiffID
--         from [sma_TRN_Plaintiff]
--         where plnnCaseID = CAS.casnCaseID
--         and plnbIsPrimary = 1
--     )                   as plnnPlaintiffID 
--     into value_tab_Multi_Party_Helper_Temp   
-- from [NeedlesSLF].[dbo].[value_Indexed] V
-- JOIN [sma_TRN_cases] CAS
--     on CAS.cassCaseNumber = V.case_id
-- JOIN [IndvOrgContacts_Indexed] IOC
--     on IOC.SAGA = V.party_id
-- JOIN [sma_TRN_Defendants] D
--     on D.defnContactID=IOC.CID
--     and D.defnContactCtgID=IOC.CTG
--     and D.defnCaseID=CAS.casnCaseID
-- GO

-- update value_tab_spDamages_Helper set PlaintiffID=A.plnnPlaintiffID
-- from value_tab_Multi_Party_Helper_Temp A
-- where case_id=A.cid and value_id=A.vid
-- GO


-- /* ########################################################
-- Create special damages from value
-- */
-- alter table [sma_TRN_SpDamages] disable trigger all
-- GO

-- INSERT INTO [sma_TRN_SpDamages]
-- (
--      spdsRefTable
--     ,spdnRecordID
-- 	,spddCaseID
-- 	,spddPlaintiff
-- 	,spddDamageType
-- 	,spddDamageSubType
--     ,spdnRecUserID
--     ,spddDtCreated
--     ,spdnLevelNo
--     ,spdnBillAmt
--     ,spddDateFrom
--     ,spddDateTo
-- 	,spdsComments
-- )
-- select distinct 
--     'CustomDamage'	    as spdsRefTable
--     ,NULL				as spdnRecordID
-- 	,sdh.casnCaseID		as spddCaseID
-- 	,sdh.PlaintiffID	as spddPlaintiff
-- 	,(
--         select top 1 spdamagetypeid
--         from sma_MST_SpecialDamageType
--         where SpDamageTypeDescription = 'Other'
--     )           		as spddDamageType
-- 	,(
--         select top 1 SpDamageSubTypeID
--         from sma_MST_SpecialDamageSubType 
-- 		where SpDamageSubTypeDescription = vc.[description]
--             and spdamagetypeid = (
--                                     select spdamagetypeid
--                                     from sma_MST_SpecialDamageType
--                                     where SpDamageTypeDescription = 'Other')
--     )		            as spddDamageSubType
--     ,368				as spdnRecUserID
--     ,getdate()		    as spddDtCreated
--     ,0					as spdnLevelNo
--     ,v.total_value	    as spdnBillAmt
--     ,case
--         when v.[start_date] between '1900-01-01' and '2079-06-01'
--             then v.[start_date]
--         else null
--         end	            as spddDateFrom
--     ,case
--         when v.stop_date between '1900-01-01' and '2079-06-01'
--             then v.stop_date
--         else null
--         end		        as spddDateTo
-- 	,'Provider: '
--         + SDH.[ProviderName]
--         + char(13)
--         + v.memo       	as spdsComments
-- FROM [NeedlesSLF].[dbo].[value_Indexed] V
-- JOIN [NeedlesSLF].[dbo].[value_Code] VC
--     on v.code = vc.code
-- JOIN [value_tab_spDamages_Helper] SDH
--     on v.value_id = sdh.value_id
-- WHERE v.code in (SELECT code FROM #SpDmgValueCodes)
-- GO

alter table [sma_TRN_SpDamages] disable trigger all

/* ##############################################
Create special damages from user_tab_data
*/
INSERT INTO [sma_TRN_SpDamages]
(
    spdsRefTable
    ,spdnRecordID
	,spddCaseID
	,spddPlaintiff
	,spddDamageType
	,spddDamageSubType
    ,spdnRecUserID
    ,spddDtCreated
    ,spdnLevelNo
    ,spdnBillAmt
    ,spddDateFrom
    ,spddDateTo
	,spdsComments
)
select distinct 
    'CustomDamage'	    as spdsRefTable
    ,NULL				as spdnRecordID
	,cas.casnCaseID		as spddCaseID
	,p.plnnPlaintiffID	as spddPlaintiff
	,(
        select top 1 spdamagetypeid
        from sma_MST_SpecialDamageType
        where SpDamageTypeDescription = 'Other'
    )           		as spddDamageType
	,null               as spddDamageSubType
    ,368				as spdnRecUserID
    ,getdate()		    as spddDtCreated
    ,0					as spdnLevelNo
    ,u.Total_Damages    as spdnBillAmt
    ,null                 as spddDateFrom
    ,null                 as spddDateTo
    ,null                   as spdsComments
FROM [NeedlesSLF].[dbo].[user_tab_data] u
join [sma_trn_cases] cas
    on cas.cassCaseNumber = convert(varchar,u.case_id)
JOIN sma_trn_plaintiff p
	on p.plnnCaseID = cas.casnCaseID
	and p.plnbIsPrimary = 1
WHERE isnull(u.Total_Damages,0) <> 0
GO

alter table [sma_TRN_SpDamages] enable trigger all