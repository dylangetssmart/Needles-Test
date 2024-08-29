
--use [SA]
--GO

/* ########################################################
user_tab_data.Litigation_Fee -> Firm Expenses
    - Firm expenses comprised of:
        select
            stlnGrossAttorneyFee
            ,stlnCBAFee
            ,stlnOther
            ,stlnForwarder
        from sma_TRN_Settlements
    - Amount stored in stlnOther
*/

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
	stlnForwarder,               --referrer
	stlnOther,
    MedicalBills,
	InterestOnDisbursement,
    stlsComments,
    stlTypeID,
	stldSettlementDate,
	saga
)
select 
    cas.casnCaseID					as stlnCaseID
    ,null                           as stlnSetAmt
    ,null							as stlnNet
    ,null							as stlnNetToClientAmt
    ,pln.plnnPlaintiffID    		as stlnPlaintiffID
    ,null							as stlnStaffID
    ,null							as stlnLessDisbursement
    ,null                           as stlnGrossAttorneyFee
    ,NULL							as stlnForwarder    --Referrer
    ,d.Litigation_Fee               as stlnOther
    ,d.Medpay_Fee                   as MedicalBills
    ,null							as InterestOnDisbursement
    ,''                             as [stlsComments]
    ,null                           as stlTypeID
    ,null                           as stldSettlementDate
    ,d.case_id						as saga
from [NeedlesSLF].[dbo].[user_tab_data] d
    join sma_trn_cases cas
        on cas.cassCaseNumber = d.case_id
    join sma_TRN_Plaintiff pln
        on cas.casnCaseID = pln.plnnCaseID
where isnull(d.Medpay_Fee,0) <> 0 or isnull(d.Litigation_Fee,0) <> 0

alter table [sma_TRN_Settlements] enable trigger all
GO

