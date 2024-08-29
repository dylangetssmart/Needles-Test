-- use [SANeedlesSLF]
GO

SET QUOTED_IDENTIFIER ON;
/*
alter table [sma_TRN_CalendarAppointments] disable trigger all
delete from [sma_TRN_CalendarAppointments]
DBCC CHECKIDENT ('[sma_TRN_CalendarAppointments]', RESEED, 0);
alter table [sma_TRN_CalendarAppointments] disable trigger all

alter table [sma_trn_AppointmentStaff] disable trigger all
delete from [sma_trn_AppointmentStaff]
DBCC CHECKIDENT ('[sma_trn_AppointmentStaff]', RESEED, 0);
alter table [sma_trn_AppointmentStaff] disable trigger all
*/

---(0)---
INSERT INTO [sma_MST_ActivityType]
(
	attsDscrptn
	,attnActivityCtg
)
SELECT
	A.ActivityType
	,(
		select atcnPKId
		FROM sma_MST_ActivityCategory
		where atcsDscrptn = 'Non-Case Related Appointment'
	)
FROM
	(
		SELECT DISTINCT
			appointment_type as ActivityType
		FROM NeedlesSLF.[dbo].[calendar] CAL
		where isnull(CAL.appointment_type,'') <> ''
			and isnull(CAL.casenum,0) = 0 
EXCEPT
SELECT
	attsDscrptn as ActivityType
	FROM sma_MST_ActivityType 
	WHERE attnActivityCtg = (
								select atcnPKId
								FROM sma_MST_ActivityCategory
								where atcsDscrptn = 'Non-Case Related Appointment'
							)
	and isnull(attsDscrptn,'') <> '' 
) A
GO

---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_CalendarAppointments'))
begin
    ALTER TABLE [sma_TRN_CalendarAppointments] ADD [saga] [varchar](100) NULL; 
end
GO


----(1)-----
INSERT INTO [sma_TRN_CalendarAppointments]
(
	[FromDate]
	,[ToDate]
	,[AppointmentTypeID]
	,[ActivityTypeID]
	,[CaseID]
	,[LocationContactID]
	,[LocationContactGtgID]
	,[JudgeID]
	,[Comments]
	,[StatusID]
	,[Address]
	,[Subject]
	,[RecurranceParentID]
	,[AdjournedID]
	,[RecUserID]
	,[DtCreated]
	,[ModifyUserID]
	,[DtModified]
	,[DepositionType]
	,[Deponants]
	,[OriginalAppointmentID]
	,[OriginalAdjournedID]
	,[RecurrenceId]
	,[WorkPlanItemId]
	,[AutoUpdateAppId]
	,[AutoUpdated]
	,[AutoUpdateProviderId]
	,[saga]
)

SELECT 
    case -- FromDate
		when CAL.[start_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[start_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(CAL.[start_date] AS DATETIME) + CAST(CAL.[start_time] AS DATETIME) AS DATETIME)
		when CAL.[start_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[start_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(CAL.[start_date] AS DATETIME) + CAST('00:00:00' AS DATETIME) AS DATETIME)
		else '1900-01-01'
		end					  as [FromDate]
    ,case -- ToDate
		when CAL.[stop_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[stop_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(CAL.[stop_date] AS DATETIME) + CAST(CAL.[stop_time] AS DATETIME) AS DATETIME)  
		when CAL.[stop_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[stop_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(CAL.[stop_date] AS DATETIME) + CAST('00:00:00' AS DATETIME) AS DATETIME)  
		else '1900-01-01'
		end					  as [ToDate]
	,(
		select ID
		FROM [SANeedlesSLF].[dbo].[sma_MST_CalendarAppointmentType]
		where AppointmentType = 'Non-Case related Office'
	)							as [AppointmentTypeID]
	,case -- ActivityTypeID
		when isnull(CAL.appointment_type,'') <> ''
			then (
					select attnActivityTypeID
					from sma_MST_ActivityType 
					where attnActivityCtg = (
												select atcnPKId
												FROM sma_MST_ActivityCategory
												where atcsDscrptn = 'Non-Case Related Appointment'
											)
					and attsDscrptn = CAL.appointment_type )
		else (
				select attnActivityTypeID
				from [sma_MST_ActivityType] 
				where attnActivityCtg = (
											select atcnPKId
											FROM sma_MST_ActivityCategory
											where atcsDscrptn='Non-Case Related Appointment'
										)
				and attsDscrptn = 'Appointment'
			)
		end				   as [ActivityTypeID]
	,null				   as [CaseID]
	,null				   as [LocationContactID]
	,null				   as [LocationContactGtgID]
    ,null				   as [JudgeID]
	,isnull('party name : ' + nullif(CAL.[party_name],'')
		+ CHAR(13),'')
		+ isnull('short notes : ' + nullif(CAL.[short_notes],'') + CHAR(13),'')
		+ ''				as [Comments]
	,case  --StatusID
		when CAL.status = 'Canceled'
			then (
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Canceled'
				)
		when CAL.status = 'Done'
			then (
					select [StatusId] 
					from [sma_MST_AppointmentStatus] 
					where [StatusName]='Completed'
				)
		when CAL.status = 'No Show'
			then (
					select [StatusId] 
					from [sma_MST_AppointmentStatus] 
					where [StatusName]='Open'
				)
		when CAL.status = 'Open'
			then (
					select [StatusId]
					 from [sma_MST_AppointmentStatus]
					  where [StatusName]='Open'
					)
		when CAL.status = 'Postponed'
			then (
					select [StatusId] 
					from [sma_MST_AppointmentStatus] 
					where [StatusName]='Adjourned'
				)
		when CAL.status = 'Rescheduled'
			then (
					select [StatusId] 
					from [sma_MST_AppointmentStatus] 
					where [StatusName]='Adjourned'
				)
		else (
				select [StatusId]
				from [sma_MST_AppointmentStatus]
				where [StatusName]='Open'
			)
		end					as [StatusID]
	,null				 	as [Address]
	,left(CAL.subject,120) 	as [Subject]
	,null 					as [RecurranceParentID]
	,null 					as [AdjournedID]
	,368					as [RecUserID]
	,getdate()			  	as [DtCreated]
	,null				  	as [ModifyUserID]
	,null				  	as [DtModified]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,'Non-Case:' + convert(varchar,CAL.calendar_id)	  as [SAGA]
FROM NeedlesSLF.[dbo].[calendar] CAL
where isnull(CAL.casenum,0) = 0

------(2)-----
INSERT INTO [sma_trn_AppointmentStaff]
(
	[AppointmentId]
	,[StaffContactId]
)
SELECT APP.AppointmentID,I.cinnContactID
FROM [sma_TRN_CalendarAppointments] APP
JOIN NeedlesSLF.[dbo].[calendar] CAL
	on APP.saga = 'Non-Case:' + convert(varchar,CAL.calendar_id)
JOIN [sma_MST_IndvContacts] I
	on I.cinsGrade = CAL.staff_id
	and isnull(CAL.staff_id,'')<>'' 

