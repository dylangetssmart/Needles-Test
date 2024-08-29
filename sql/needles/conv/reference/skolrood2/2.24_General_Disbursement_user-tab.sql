/* ########################################################
8/2/2024 - Create disbursements from user_tab_data.Firm_Expenses
*/

-- 1) Create disbursement type
INSERT INTO [sma_MST_DisbursmentType]
(
    disnTypeCode
    ,dissTypeName
)
VALUES
(
    null
    ,'Firm Expenses'
)

-- 2) Create Disbursements
alter table [sma_TRN_Disbursement] disable trigger all

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
    cas.casnCaseID		                    as disnCaseID
    ,null                                   as disdCheckDt
    ,null	                                as disnPayeeContactCtgID
    ,null           	                    as disnPayeeContactID
    ,d.Firm_Expenses                        as disnAmount
    ,pln.plnnPlaintiffID                    as disnPlaintiffID
    ,(
        select disnTypeID
        from [sma_MST_DisbursmentType]
        where dissTypeName = 'Firm Expenses'
    )                                       as dissDisbursementType
    ,null           	                    as UniquePayeeID
    ,null                                   as dissDescription
    ,'user_tab_data > Firm Expenses'        as dissComments
    ,(
                select Id
                FROM [sma_MST_CheckRequestStatus]
                where [Description] = 'Review'
    )                                       as disnCheckRequestStatus
    ,null                                   as disdBillDate
    ,null                                   as disdDueDate
    ,368                                    as disnRecUserID
    ,getdate()                              as disdDtCreated
	,0                                      as disnRecoverable
    ,d.case_id			                    as saga
from [NeedlesSLF].[dbo].[user_tab_data] d
    join sma_trn_cases cas
        on cas.cassCaseNumber = d.case_id
    join sma_TRN_Plaintiff pln
        on cas.casnCaseID = pln.plnnCaseID
where isnull(d.Firm_Expenses,0) <> 0
GO

alter table [sma_TRN_Disbursement] enable trigger all


select
    stlnGrossAttorneyFee
    ,stlnCBAFee
    ,stlnOther
    ,stlnForwarder
from sma_TRN_Settlements