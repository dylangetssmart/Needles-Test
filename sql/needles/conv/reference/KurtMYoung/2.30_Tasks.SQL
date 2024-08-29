use [SANeedlesKMY]
GO

/*
alter table [sma_TRN_TaskNew] disable trigger all
delete from [sma_TRN_TaskNew]
DBCC CHECKIDENT ('[sma_TRN_TaskNew]', RESEED, 0);
alter table [sma_TRN_TaskNew] disable trigger all
*/

----(0)----
--INSERT INTO [sma_MST_TaskCategory] (tskCtgDescription)
--SELECT DISTINCT Type_Of_Record 
--FROM NeedlesGMA..user_tab2_data 
--WHERE Type_of_Record in ('Accident Report', 'Criminal', 'Death Cert', 'Dec Page', 'DMV Record', 'Education', 
--					'Employment', 'Expert Opinion', 'Funeral', 'Photograph', 'Tax', 'Court Transcript', 'Police Notes', 
--					'Depo Trans.', 'FCE', 'IME', 'SDT by Employer', 'Lost Wages', 'Questionnaire')
--EXCEPT
--SELECT tskCtgDescription FROM [sma_MST_TaskCategory] 

GO
---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_TaskNew'))
begin
    ALTER TABLE [sma_TRN_TaskNew] ADD [saga] varchar(20); 
end
GO

---(1)---
alter table [sma_TRN_TaskNew] disable trigger all
GO

INSERT INTO [sma_TRN_TaskNew]
(
       [tskCaseID]
      ,[tskDueDate]
      ,[tskStartDate]
	  ,[tskCompletedDt]
      ,[tskRequestorID]
      ,[tskAssigneeId]
      ,[tskReminderDays]
      ,[tskDescription]
	  ,[tskCreatedDt]
      ,[tskCreatedUserID]
      ,[tskMasterID]
      ,[tskCtgID]
      ,[tskSummary]
      ,[tskPriority]
      ,[tskCompleted]
	 ,[saga]
)  
SELECT 
    CAS.casnCaseID																		as [tskCaseID]
	,case
		when d.Date_Due between '1900-01-01' and '2079-06-06'
			then D.Date_Due
		else null
		end																				as [tskDueDate]
    ,null																				as [tskStartDate]
	,null																				as [tskCompletedDt]
    ,null																				as [tskRequestorID]
    ,(
		select usrnUserID
		From sma_mst_users
		where saga = D.Assigned_To
	)																					as [tskAssigneeId]
    ,null																				as [tskReminderDays]
    ,null																				as [tskDescription]
    ,null																				as [tskCreatedDt]
    ,null																				as tskCreatedUserID
    ,(
		select tskMasterID 
		from sma_mst_Task_Template
		where tskMasterDetails = 'Custom Task'
	)																					as [tskMasterID]
    ,null																				as [tskCtgID]
    ,D.Tickle_Description																as [tskSummary]  --task subject--
    ,(
		select uId
		from PriorityTypes
		where PriorityType = 'Normal'
	)																					as [tskPriority]
	,(
		select StatusID
		from TaskStatusTypes
		where StatusType = 'Not Started'
	)																					as [tskCompleted]
    ,null																				as [saga]
FROM NeedlesKMY.[dbo].[user_tab8_data] D
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = D.case_id
where Date_Due is not null
GO

alter table [sma_TRN_TaskNew] enable trigger all
GO