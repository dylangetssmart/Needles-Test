use [SA]
GO
--truncate table [sma_TRN_CaseUserTime]


--select * From sma_MST_ActivityCodes
---(0)---
INSERT INTO sma_MST_ActivityCodes ( ActivityCodeDescription )
(
	SELECT DISTINCT VC.[description] 
	FROM [TestNeedles].[dbo].[value] V
	JOIN [TestNeedles].[dbo].[value_code] VC on VC.code=V.code 
	WHERE isnull(V.code,'') in ( 'T/B' ) 
EXCEPT 
SELECT ActivityCodeDescription FROM sma_MST_ActivityCodes
)
GO

---(0)---
INSERT INTO sma_MST_CaseTypeActivityCodeRelationship ( CaseTypeID,ActivityCodeID )
SELECT DISTINCT 0, (SELECT ActivityCodeID FROM sma_MST_ActivityCodes WHERE ActivityCodeDescription=vc.[description])
FROM [TestNeedles].[dbo].[value] V
JOIN [TestNeedles].[dbo].[value_code] VC on VC.code=V.code 
WHERE isnull(V.code,'') in ( 'T/B' ) 
EXCEPT SELECT CaseTypeID,ActivityCodeID FROM sma_MST_CaseTypeActivityCodeRelationship 
GO

---(1)---
alter table [sma_TRN_CaseUserTime] disable trigger all
GO
  
INSERT INTO [sma_TRN_CaseUserTime]
(      
	  [cutnCaseID]
      ,[cutnStaffID]
      ,[cutnActivityID]
      ,[cutdFromDtTime]
      ,[cutdToDtTime]
      ,[cutsDuration]
      ,[cutnBillingRate]
      ,[cutnBillingAmt]
      ,[cutsComments]
      ,[cutnRecUserID]
      ,[cutdDtCreated]
      ,[cutnModifyUserID]
      ,[cutdDtModified]
      ,[cutnLevelNo]
      ,[cutnAddTime]
	 ,[cutnPlaintiffID]
)
SELECT 
	   CAS.casnCaseID		as cutnCaseID,
	   ( SELECT U.usrnUserID FROM sma_MST_Users U WHERE U.usrsLoginID=v.staff_created )	   as cutnStaffID ,
	   (SELECT ActivityCodeID FROM sma_MST_ActivityCodes WHERE ActivityCodeDescription=vc.[description])
							as cutnActivityID,
	   CASE WHEN v.[start_date] between '1900-01-01' and '2079-06-06' THEN convert(datetime,v.[start_date]) 
		  else null  end	as cutdFromDtTime,
	   case when v.[stop_date] between '1900-01-01' and '2079-06-06' THEN convert(datetime,v.[stop_date]) 
		  else null end		as cutdToDtTime,
		CASE when left(v.num_periods,charindex('.',v.num_periods)-1) < 10 then '0'+left(v.num_periods,charindex('.',v.num_periods)-1)+':' 
					else convert(Varchar(7), left(v.num_periods,charindex('.',v.num_periods)-1)) +':' end + 
			CASE WHEN ROUND ( ((v.num_periods * 60) % 60), 1) < 10 then '0'+convert(varchar, convert(int, ROUND ( ((v.num_periods * 60) % 60), 1))) 
					else convert(Varchar, convert(int, ROUND ( ((v.num_periods * 60) % 60), 1))) end		as [cutsDuration],
	   v.Rate				as cutnBillingRate,
	   null					as cutnBillingAmt,
	   left(convert(varchar(2000),v.[memo]),2000) 
							as cutsComments,
	   368					as cutnRecUserID,
	   getdate()			as [cutdDtCreated],
	   null					as cutnModifyUserID,
	   null					as cutdDtModified,
	   0					as cutnLevelNo,
	   0				    as cutnAddTime,
	   T.plnnPlaintiffID	as cutnPlaintiffID
--select *
FROM [TestNeedles].[dbo].[value] V
JOIN [TestNeedles].[dbo].[value_code] VC on VC.code=V.code 
JOIN [sma_TRN_Cases] CAS on CAS.cassCaseNumber = v.case_id  
LEFT JOIN [TestNeedles].[dbo].[party_Indexed] P on P.party_id=V.party_id and P.case_id=v.case_id
LEFT JOIN [sma_TRN_Plaintiff] T on T.[saga_party]=P.TableIndex
WHERE v.code = 'T/B'
GO
--
alter table [sma_TRN_CaseUserTime] enable trigger all
GO

