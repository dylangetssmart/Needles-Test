-- use [SANeedlesSLF]
go
/*
alter table [sma_TRN_CriticalDeadlines] disable trigger all
delete [sma_TRN_CriticalDeadlines]
DBCC CHECKIDENT ('[sma_TRN_CriticalDeadlines]', RESEED, 0);
alter table [sma_TRN_CriticalDeadlines] enable trigger all
*/



/* ####################################
Create from User Field: user_case_data.Date_Application_Filed
-- DeadlineType 'Date Application Filed' created via 2.15_CriticalDeadLines
*/

ALTER TABLE [sma_TRN_CriticalDeadlines] DISABLE TRIGGER ALL
GO

insert into [sma_TRN_CriticalDeadlines]
(
	[crdnCaseID]				
	,[crdnCriticalDeadlineTypeID]
	,[crddDueDate]
	,[crdsRequestFrom]
	,[ResponderUID]
)
select
	casnCaseID								as [crdnCaseID]
	,(
		select cdtnCriticalTypeID
		from [sma_MST_CriticalDeadlineTypes]
		where cdtbActive = 1
			and cdtsDscrptn = 'Date Application Filed'
		)										as [crdnCriticalDeadlineTypeID]
	,case 
		when n.Date_Application_Filed_Case between '1900-01-01' and '2079-06-01'
			then n.Date_Application_Filed_Case
		else null
		end										as [crddDueDate]
	,null										as [crdsRequestFrom]
	,null										as [ResponderUID]
FROM NeedlesSLF.[dbo].case_intake n
	JOIN [sma_TRN_Cases] C on C.saga = N.ROW_ID
where isnull(n.Date_Application_Filed_Case, '') <> ''



-----
ALTER TABLE [sma_TRN_CriticalDeadlines] ENABLE TRIGGER ALL
GO
-----


---(Appendix)---
ALTER TABLE sma_TRN_CriticalDeadlines DISABLE TRIGGER ALL
GO

UPDATE [sma_TRN_CriticalDeadlines] 
SET crddCompliedDate=getdate()
WHERE crddDueDate < getdate()
GO

ALTER TABLE sma_TRN_CriticalDeadlines ENABLE TRIGGER ALL
GO