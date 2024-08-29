-- use SANeedlesSLF
GO

/*
alter table [sma_TRN_CaseStatus] disable trigger all
delete from [sma_TRN_CaseStatus]
DBCC CHECKIDENT ('[sma_TRN_CaseStatus]', RESEED, 0);
alter table [sma_TRN_CaseStatus] enable trigger all
*/

---(0)---
/*
Add unique case statuses from Needles..class to sma_MST_CaseStatus
*/
INSERT INTO sma_MST_CaseStatus ( csssDescription,cssnStatusTypeID )
SELECT 
    A.[name],
    (select stpnStatusTypeID from sma_MST_CaseStatusType where stpsStatusType='Status')
FROM
	(
		/*
		Retrieves distinct descriptions from the NeedlesSLF.dbo.class table,
		joining with the NeedlesSLF.dbo.cases table
		to filter the classes that are associated with cases.
		*/
		SELECT DISTINCT [description] as [name]
		FROM NeedlesSLF.[dbo].[class]
		JOIN NeedlesSLF.[dbo].[cases] C
			on C.class=classcode

		/*
		Adds a hardcoded status description 'Conversion Case No Status'
		to the list of distinct descriptions.
		*/
		UNION SELECT 'Conversion Case No Status'
		
		EXCEPT
		
		/*
		Excludes any descriptions that already exist in the sma_MST_CaseStatus table
		with a status type ID corresponding to 'Status'.
		*/
		SELECT csssDescription as [name]
		FROM sma_MST_CaseStatus
		WHERE cssnStatusTypeID = 
			(
				select stpnStatusTypeID
				from sma_MST_CaseStatusType
				where stpsStatusType='Status'
			)
	) A
GO

---(1)---
ALTER TABLE [sma_TRN_CaseStatus] DISABLE TRIGGER ALL
GO
---------

INSERT INTO [sma_TRN_CaseStatus] (
	[cssnCaseID],
	[cssnStatusTypeID],
	[cssnStatusID],
	[cssnExpDays],
	[cssdFromDate],
	[cssdToDt],
	[csssComments],
	[cssnRecUserID],
	[cssdDtCreated],
	[cssnModifyUserID],
	[cssdDtModified],
	[cssnLevelNo],
	[cssnDelFlag]
)
SELECT
    CAS.casnCaseID
	,(
		select stpnStatusTypeID
		from sma_MST_CaseStatusType
		where stpsStatusType='Status'
	)																	as [cssnStatusTypeID]
    ,case 
		when C.close_date between '1900-01-01' and '2079-06-06'	then
			( 
				select cssnStatusID
				from sma_MST_CaseStatus
				where csssDescription='Closed Case'
			)
		when exists (
						select *
						from sma_MST_CaseStatus
						where csssDescription=CL.[description]
					)
					then (
							select cssnStatusID
							from sma_MST_CaseStatus
							where csssDescription=CL.[description]
						)
		else (
				select cssnStatusID
				from sma_MST_CaseStatus
				where csssDescription='Conversion Case No Status'
				)
		end																as [cssnStatusID]
    ,''																	as [cssnExpDays]
	,case 
		when c.close_date between '1900-01-01' and '2079-06-06' then c.close_Date
		else GETDATE()
		end																as [cssdFromDate]
    ,null																as [cssdToDt]
    ,case
		when C.close_date between '1900-01-01' and '2079-06-06' 
			then 'Prior Status : ' + CL.[description]
		else ''
	   end	+char(13) +
	   ''																as [csssComments]
    ,368
    ,getdate()															as [cssdDtCreated]
    ,null
	,null
	,null
	,null 
FROM [sma_trn_cases] CAS
JOIN NeedlesSLF.[dbo].[cases_Indexed] C
	on convert(varchar,C.casenum)=CAS.cassCaseNumber
LEFT JOIN NeedlesSLF.[dbo].[class] CL
	on C.class=CL.classcode
GO

--------
ALTER TABLE [sma_TRN_CaseStatus] ENABLE TRIGGER ALL
GO
--------


---(2)---
ALTER TABLE [sma_trn_cases] DISABLE TRIGGER ALL
GO
---------
UPDATE sma_trn_cases set casnStatusValueID=STA.cssnStatusID
FROM sma_TRN_CaseStatus STA
WHERE STA.cssnCaseID=casnCaseID
GO

ALTER TABLE [sma_trn_cases] ENABLE TRIGGER ALL
GO


