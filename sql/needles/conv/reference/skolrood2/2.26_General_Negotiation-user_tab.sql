-- use [SANeedlesSLF]
--go
/*

delete [sma_TRN_Negotiations]
DBCC CHECKIDENT ('[sma_TRN_Negotiations]', RESEED, 1);
alter table [sma_TRN_Negotiations] enable trigger all

alter table [sma_TRN_Settlements] disable trigger all
delete [sma_TRN_Settlements]
DBCC CHECKIDENT ('[sma_TRN_Settlements]', RESEED, 1);

*/

--(0)--
alter table [sma_TRN_Negotiations] disable trigger all


/* ########################################################
1 - Atty Final Offer
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Atty_Final_Offer_Date between '1900-01-01' and '2079-12-31'
			then d.Atty_Final_Offer_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Atty_Final_Offer												as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Attn Final Offer' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Atty_Final_Offer,'') <> '' or isnull(d.Atty_Final_Offer_Date,'') <> ''

/* ########################################################
2 - Atty First Offer
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Atty_First_Offer_Date between '1900-01-01' and '2079-12-31'
			then d.Atty_First_Offer_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Atty_First_Offer												as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Atty First Offer' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Atty_First_Offer,'') <> '' or isnull(d.Atty_First_Offer_Date,'') <> ''

/* ########################################################
3 - Adjuster's Final Offer
	- Adj_Final_Offer_Date
	- Adjusters_Final_Offer
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Adj_Final_Offer_Date between '1900-01-01' and '2079-12-31'
			then d.Adj_Final_Offer_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Adjusters_Final_Offer										as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Adjuster''s Final Offer' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Adjusters_Final_Offer,'') <> '' or isnull(d.Adj_Final_Offer_Date,'') <> ''

/* ########################################################
4 - Adjuster's First Offer After Serv Date
	- Adj_1st_Offer_AS_Date
	- Adj_First_Offer_After_Svc
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Adj_1st_Offer_AS_Date between '1900-01-01' and '2079-12-31'
			then d.Adj_1st_Offer_AS_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Adj_First_Offer_After_Svc									as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Adjuster''s First Offer After Serv Date'						as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Adj_First_Offer_After_Svc,'') <> '' or isnull(d.Adj_1st_Offer_AS_Date,'') <> ''

/* ########################################################
5 - Adjuster's Final Offer After Serv Date
	- Adj_Final_Offer_Aft_Svc
	- Adj_FO_After_Serv_Date
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Adj_FO_After_Serv_Date between '1900-01-01' and '2079-12-31'
			then d.Adj_FO_After_Serv_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Adj_Final_Offer_Aft_Svc										as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Adjuster''s Final Offer After Serv Date'						as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Adj_FO_After_Serv_Date,'') <> '' or isnull(d.Adj_Final_Offer_Aft_Svc,'') <> ''

/* ########################################################
6 - Client Settle
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.Client_Settle_Auth_Date between '1900-01-01' and '2079-12-31'
			then d.Client_Settle_Auth_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,d.Clients_Settle_Auth											as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																	as [negnLevelNo]
    ,'Client''s Settle Auth.' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Client_Settle_Auth_Date,'') <> ''or isnull(d.Clients_Settle_Auth,'') <> ''

/* ########################################################
7 - Adjuster's First Offer
	- Adjusters_First_Offer
	- First_Offer_Date
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,case
		when d.First_Offer_Date between '1900-01-01' and '2079-12-31'
			then d.First_Offer_Date
	   else null
		end															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,null															as [negnDemand]
	,d.Adjusters_First_Offer										as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																	as [negnLevelNo]
    ,'Adjuster''s First Offer' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Offer_Date,'') <> '' or isnull(d.Adjusters_First_Offer,'') <> ''

/* ########################################################
8 - First Demand Amount
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.First_Demand_Amount											as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'First Demand Amount' 											as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Demand_Amount,'') <> ''

/* ########################################################
9 - First Dmd After Adj Final
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.First_Dmd_After_Adj_Final									as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'First Dmd After Adj Final'									as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Dmd_After_Adj_Final,'') <> ''

/* ########################################################
10 - First Dmd After Atty F.O.
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.First_Dmd_After_Atty_FO										as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'First Dmd After Atty F.O.'									as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Dmd_After_Atty_FO,'') <> ''

/* ########################################################
11 - First Dmd after F.O.A.S.
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.First_Dmd_after_FOAS											as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'First Dmd after F.O.A.S.'										as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Dmd_after_FOAS,'') <> ''

/* ########################################################
12 - First Dmd After Service
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.First_Dmd_After_Service										as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'First Dmd After Service'										as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.First_Dmd_After_Service,'') <> ''

/* ########################################################
13 - Last Dmd Before Adj Final
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.Last_Dmd_Before_Adj_Final									as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Last Dmd Before Adj Final'									as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Last_Dmd_Before_Adj_Final,'') <> ''

/* ########################################################
14 - Last Dmd Before Atty F.O.
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.Last_Dmd_Before_Atty_FO										as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Last Dmd Before Atty F.O.'									as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Last_Dmd_Before_Atty_FO,'') <> ''

/* ########################################################
15 - Last Dmd Before F.O.A.S.
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.Last_Dmd_Before_FOAS											as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Last Dmd Before F.O.A.S.'										as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Last_Dmd_Before_FOAS,'') <> ''

/* ########################################################
16 - Outside Atty Fee Amount
*/
INSERT INTO [sma_TRN_Negotiations]
(      [negnCaseID]
      ,[negsUniquePartyID]
      ,[negdDate]
      ,[negnStaffID]
      ,[negnPlaintiffID]
      ,[negbPartiallySettled]
      ,[negnClientAuthAmt]
      ,[negbOralConsent]
      ,[negdOralDtSent]
      ,[negdOralDtRcvd]
      ,[negnDemand]
      ,[negnOffer]
      ,[negbConsentType]
      ,[negnRecUserID]
      ,[negdDtCreated]
      ,[negnModifyUserID]
      ,[negdDtModified]
      ,[negnLevelNo]
      ,[negsComments]
 )
SELECT 
    CAS.casnCaseID													as [negnCaseID]
	,null															as [negsUniquePartyID]
    ,null															as [negdDate]
    ,null 															as [negnStaffID]
	,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = cas.casnCaseID
		and plnbIsPrimary = 1
	)																as [negnPlaintiffID]
	,null															as [negbPartiallySettled]
	,null															as [negnClientAuthAmt]
	,null															as [negbOralConsent]
	,null															as [negdOralDtSent]
	,null															as [negdOralDtRcvd]
	,d.Outside_Atty_Fee_Amount										as [negnDemand]
	,null															as [negnOffer]
	,null															as [negbConsentType]
	,368
	,getdate()
	,368
	,getdate()
	,0																as [negnLevelNo]
    ,'Outside Atty Fee Amount'										as [negsComments]
from NeedlesSLF..user_tab_data d
JOIN [sma_TRN_cases] CAS
	on CAS.cassCaseNumber = convert(varchar,d.case_id)
where isnull(d.Outside_Atty_Fee_Amount,'') <> ''

/* ########################################################
If MedPay Fee exists, create a Settlement.
Otherwise Negotiation
*/

-- INSERT INTO [sma_TRN_Negotiations]
-- (      [negnCaseID]
--       ,[negsUniquePartyID]
--       ,[negdDate]
--       ,[negnStaffID]
--       ,[negnPlaintiffID]
--       ,[negbPartiallySettled]
--       ,[negnClientAuthAmt]
--       ,[negbOralConsent]
--       ,[negdOralDtSent]
--       ,[negdOralDtRcvd]
--       ,[negnDemand]
--       ,[negnOffer]
--       ,[negbConsentType]
--       ,[negnRecUserID]
--       ,[negdDtCreated]
--       ,[negnModifyUserID]
--       ,[negdDtModified]
--       ,[negnLevelNo]
--       ,[negsComments]
--  )
-- SELECT 
--     CAS.casnCaseID													as [negnCaseID]
-- 	,null															as [negsUniquePartyID]
--     ,null															as [negdDate]
--     ,null 															as [negnStaffID]
-- 	,(
-- 		select plnnPlaintiffID
-- 		FROM [sma_TRN_Plaintiff]
-- 		WHERE plnnCaseID = cas.casnCaseID
-- 		and plnbIsPrimary = 1
-- 	)																as [negnPlaintiffID]
-- 	,null															as [negbPartiallySettled]
-- 	,null															as [negnClientAuthAmt]
-- 	,null															as [negbOralConsent]
-- 	,null															as [negdOralDtSent]
-- 	,null															as [negdOralDtRcvd]
-- 	,d.Outside_Atty_Fee_Amount										as [negnDemand]
-- 	,null															as [negnOffer]
-- 	,null															as [negbConsentType]
-- 	,368
-- 	,getdate()
-- 	,368
-- 	,getdate()
-- 	,0																as [negnLevelNo]
--     ,'Outside Atty Fee Amount'										as [negsComments]
-- from NeedlesSLF..user_tab_data d
-- JOIN [sma_TRN_cases] CAS
-- 	on CAS.cassCaseNumber = convert(varchar,d.case_id)
-- where isnull(d.Outside_Atty_Fee_Amount,'') <> ''

---
alter table [sma_TRN_Negotiations] enable trigger all
---



-- SELECT 
--     CAS.casnCaseID													as [negnCaseID]
--     -- ,(
-- 	-- 	'I' + convert(varchar,  (
-- 	-- 							select top 1 incnInsCovgID
-- 	-- 							from [sma_TRN_InsuranceCoverage] INC
-- 	-- 							where INC.incnCaseID = CAS.casnCaseID
-- 	-- 							and INC.saga = INS.insurance_id  
-- 	-- 							and INC.incnInsContactID = (
-- 	-- 														select top 1 connContactID
-- 	-- 														from [sma_MST_OrgContacts]
-- 	-- 														where saga=INS.insurer_id
-- 	-- 														)
-- 	-- 							)
-- 	-- 				)
-- 	-- )																as [negsUniquePartyID]
-- 	,null															as [negsUniquePartyID]
--     ,case
-- 		when NEG.neg_date between '1900-01-01' and '2079-12-31'
-- 			then NEG.neg_date
-- 	   else null
-- 		end															as [negdDate]
--     ,null 															as [negnStaffID]
-- 	-- ,(
-- 	-- 	select usrnContactiD
-- 	-- 	from sma_MST_Users
-- 	-- 	where saga = NEG.staff
-- 	-- )																as [negnStaffID]
-- 	,(
-- 		select plnnPlaintiffID
-- 		FROM [sma_TRN_Plaintiff]
-- 		WHERE plnnCaseID = cas.casnCaseID and plnbIsPrimary=1
-- 	)																as [negnPlaintiffID]
-- 	,null															as [negbPartiallySettled]
-- 	,case
-- 		when NEG.kind = 'Client Auth.'
-- 			then NEG.amount
-- 		else null 
-- 		end															as [negnClientAuthAmt]
-- 	,null															as [negbOralConsent]
-- 	,null															as [negdOralDtSent]
-- 	,null															as [negdOralDtRcvd]
-- 	,case
-- 		when NEG.kind = 'Demand'
-- 			then NEG.amount
-- 		else null
-- 		end															as [negnDemand]
-- 	,case
-- 		when NEG.kind IN( 'Offer','Conditional Ofr')
-- 			then NEG.amount
-- 		else null
-- 		end															as [negnOffer]
-- 	,null															as [negbConsentType]
-- 	,368
-- 	,getdate()
-- 	,368
-- 	,getdate()
-- 	,0																as [negnLevelNo]
--     ,isnull(NEG.kind + ' : ' + NULLIF(convert(varchar,NEG.amount),'') + CHAR(13) + CHAR(10),'')
-- 		+ NEG.notes													as [negsComments]