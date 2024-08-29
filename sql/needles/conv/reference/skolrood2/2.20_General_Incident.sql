-- use [SANeedlesSLF]
GO

/*
alter table [sma_TRN_Incidents] disable trigger all
delete [sma_TRN_Incidents]
DBCC CHECKIDENT ('[sma_TRN_Incidents]', RESEED, 0);
alter table [sma_TRN_Incidents] enable trigger all
*/


---
ALTER TABLE [sma_TRN_Incidents] DISABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Cases] DISABLE TRIGGER ALL
GO
---
INSERT INTO [sma_TRN_Incidents]
(
       [CaseId]
      ,[IncidentDate]
      ,[StateID]
      ,[LiabilityCodeId]
      ,[IncidentFacts]
      ,[MergedFacts]
      ,[Comments]
      ,[IncidentTime]
      ,[RecUserID]
      ,[DtCreated]
      ,[ModifyUserID]
      ,[DtModified]
)
SELECT 
	CAS.casnCaseID				as CaseId
	,case
		when ( C.[date_of_incident] between '1900-01-01' and '2079-06-06' ) 
			then convert(date,C.[date_of_incident]) 
		else null 
		end 					as IncidentDate
	,(
		select sttnStateID
		from sma_MST_States
		where sttsCode='VA'
	)							as [StateID]
	,0							as LiabilityCodeId
	,null						as IncidentFacts
	,null						as [MergedFacts]
	,null						as [Comments]
	,u.Time_of_Accident			as [IncidentTime]
	,368						as [RecUserID]
	,getdate()					as [DtCreated]
	,null						as [ModifyUserID]
	,null						as [DtModified]
FROM NeedlesSLF.[dbo].[cases_Indexed] C
	JOIN NeedlesSLF.[dbo].[user_case_data] U
		on U.casenum=C.casenum
	JOIN [sma_TRN_cases] CAS
		on CAS.cassCaseNumber = convert(varchar,C.casenum)
where ISNULL(u.Time_of_Accident, '') <> ''
                


UPDATE CAS
SET CAS.casdIncidentDate=INC.IncidentDate,
    CAS.casnStateID=INC.StateID,
    CAS.casnState=INC.StateID
FROM sma_trn_cases as CAS
LEFT JOIN sma_TRN_Incidents as INC on casnCaseID=caseid
WHERE INC.CaseId=CAS.casncaseid 

---
ALTER TABLE [sma_TRN_Incidents] ENABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Cases] ENABLE TRIGGER ALL
GO