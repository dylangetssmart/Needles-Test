
use [SANeedlesKMY]
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
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_CalendarAppointments'))
begin
    ALTER TABLE [sma_TRN_CalendarAppointments] ADD [saga] [varchar](100) NULL; 
end
GO

----(0)----
if exists (select * from sys.objects where name='CalendarJudgeStaffCourt' and type='U' )
begin
    drop table CalendarJudgeStaffCourt
end
GO

-- Construct table
select 
    CAL.calendar_id	    as CalendarId,
    CAS.casnCaseID	    as CaseID, 
    0					as Judge_Contact,
    0					as Staff_Contact, 
    0					as Court_Contact,
    0					as Court_Address,
    0					as Party_Contact
into CalendarJudgeStaffCourt
from NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
	on CAS.cassCaseNumber = CAL.casenum
where isnull(CAL.casenum,0)<>0 

-- Update Judge_Contact with cinnContactID from [sma_MST_IndvContacts]
	-- calendar.judge_link = on [sma_MST_IndvContacts].saga
update CalendarJudgeStaffCourt
set Judge_Contact=I.cinnContactID
from NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = CAL.casenum 
	JOIN [sma_MST_IndvContacts] I
		on I.saga = CAL.judge_link
		and CAL.judge_link<>0
where CAL.calendar_id=CalendarId

-- Set Staff_Contact [sma_MST_IndvContacts].cinnContactID
	-- calendar.staff_id = [sma_MST_IndvContacts].cinsGrade
update CalendarJudgeStaffCourt
set Staff_Contact=J.cinnContactID
FROM NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = CAL.casenum
	JOIN [sma_MST_IndvContacts] J
		on J.cinsGrade = CAL.staff_id
		and isnull(CAL.staff_id,'')<>'' 
where CAL.calendar_id=CalendarId

-- Set Court_Contact to [sma_MST_OrgContacts].connContactID 
-- Set Court_Address to [sma_MST_Address].addnAddressID
update CalendarJudgeStaffCourt
set Court_Contact=O.connContactID,Court_Address=A.addnAddressID
FROM NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = CAL.casenum
	JOIN [sma_MST_OrgContacts] O
		on O.saga = CAL.court_link
	JOIN [sma_MST_Address] A
		on A.addnContactID=O.connContactID
		and A.addnContactCtgID=O.connContactCtg
		and A.addbPrimary=1
WHERE CAL.calendar_id=CalendarId

-- Set Party_Contact to [sma_MST_IndvContacts].cinnContactID
update CalendarJudgeStaffCourt
set Party_Contact=J.cinnContactID
from NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = CAL.casenum
	JOIN [sma_MST_IndvContacts] J
		on J.saga = CAL.party_id 
where CAL.calendar_id=CalendarId


---(0)---
insert into [sma_MST_ActivityType]
(
	attsDscrptn
	,attnActivityCtg
)  
select
	A.ActivityType
	,(
		select atcnPKId
		FROM sma_MST_ActivityCategory
		where atcsDscrptn = 'Case-Related Appointment'
	)
from (
		select distinct 
			appointment_type as ActivityType 
		from NeedlesKMY.[dbo].[calendar] CAL
		where isnull(appointment_type,'') <> ''
		except
		select 
			attsDscrptn as ActivityType
		from sma_MST_ActivityType 
		where attnActivityCtg = (
								select atcnPKId
								FROM sma_MST_ActivityCategory
								where atcsDscrptn='Case-Related Appointment'
								)
		and isnull(attsDscrptn,'') <> '' 
	) A
GO


alter table [sma_TRN_CalendarAppointments] disable trigger all

----(1)-----
insert into [sma_TRN_CalendarAppointments]
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
select 
	case
		when CAL.[start_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[start_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(CAL.[start_date] AS DATE) AS DATETIME) + CAST(CAL.[start_time] AS TIME)  
			--then cast(cal.[start_date] as datetime)
		when CAL.[start_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[start_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(CAL.[start_date] AS DATE) AS DATETIME) + CAST('00:00:00' AS TIME)  
		else '1900-01-01'
		end						 as [FromDate]
    ,case
		when CAL.[stop_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[stop_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(CAL.[stop_date] AS DATE) AS DATETIME) + CAST(CAL.[stop_time] AS TIME)  
			--then cast(cal.[stop_date] as datetime)
		when CAL.[stop_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(CAL.[stop_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(CAL.[stop_date] AS DATE) AS DATETIME) + CAST('00:00:00' AS TIME)  
		else '1900-01-01'
		end						 as [ToDate]
	,(
		select ID
		from [sma_MST_CalendarAppointmentType]
		where AppointmentType='Case-related'
	)							as [AppointmentTypeID]
	,case
		when isnull(CAL.appointment_type,'') <> ''
			then 
				(
					select attnActivityTypeID
					from sma_MST_ActivityType
					where attnActivityCtg =
						(
							select atcnPKId
							FROM sma_MST_ActivityCategory
							where atcsDscrptn='Case-Related Appointment'
						) 
						and attsDscrptn = CAL.appointment_type
				)
		else
			(
				select attnActivityTypeID
				from [sma_MST_ActivityType] 
				where attnActivityCtg =
					(
						select atcnPKId
						from sma_MST_ActivityCategory
						where atcsDscrptn='Case-Related Appointment'
					) 
					and attsDscrptn = 'Appointment'
			)
		end					  as [ActivityTypeID]
	,CAS.casnCaseID			  as [CaseID]
	,MAP.Court_Contact		  as [LocationContactID]
	,2					      as [LocationContactGtgID]
	,MAP.Judge_Contact		  as [JudgeID],
	isnull('party name : ' + nullif(CAL.[party_name],'') + CHAR(13),'') +
	isnull('short notes : ' + nullif(CAL.[short_notes],'') + CHAR(13),'') +
	''						  as [Comments]
	,case 
		when CAL.status = 'Canceled'
			then(
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Canceled'
				)
		when CAL.status = 'Done'
			then(
					select [StatusId] 
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Completed'
				)
		when CAL.status = 'No Show'
			then(
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Open'
				)
		when CAL.status = 'Open'
			then(
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Open'
				)
		when CAL.status = 'Postponed'
			then(
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Adjourned'
				)
		when CAL.status = 'Rescheduled'
			then(
					select [StatusId]
					from [sma_MST_AppointmentStatus]
					where [StatusName]='Adjourned'
				)
		else(
				select [StatusId]
				from [sma_MST_AppointmentStatus]
				where [StatusName]='Open'
			)
		end						as [StatusID]
	,null						as [Address]
	,left(CAL.[subject],120)	as [Subject]
	,null
	,null
	,368						as [RecUserID]
	,CAL.[date_created]			as [DtCreated]
	,null						as [ModifyUserID]
	,null						as [DtModified]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,'Case-related:'+convert(varchar,CAL.calendar_id)	as [saga]
FROM NeedlesKMY.[dbo].[calendar] CAL
	JOIN [sma_TRN_Cases] CAS
		on CAS.cassCaseNumber = CAL.casenum
	JOIN CalendarJudgeStaffCourt MAP
		on MAP.CalendarId=CAL.calendar_id
where isnull(CAL.casenum,0)<>0
GO


/* ####################################
user_case_data Pass 1
- inital_appt -> start date
- appt_time -> start time
- appointment type = "Initial Appt"
*/

-- Create appointment type "Initial Appt"
INSERT INTO [sma_MST_ActivityType]
(
    attsDscrptn,
    attnActivityCtg
)  
SELECT
    'Initial Appt' AS [attsDscrptn],
    (
        SELECT atcnPKId
        FROM sma_MST_ActivityCategory
        WHERE atcsDscrptn = 'Case-Related Appointment'
    ) AS [attnActivityCtg]
WHERE NOT EXISTS (
    SELECT 1
    FROM [sma_MST_ActivityType]
    WHERE attsDscrptn = 'Initial Appt'
)
GO

-- Create calendar appointments
insert into [sma_TRN_CalendarAppointments]
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
select 
	case
		when ud.[initial_appt] between '1900-01-01' and '2079-06-06' and convert(time,isnull(ud.[appt_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(ud.[initial_appt] AS DATE) AS DATETIME) + CAST(ud.[appt_time] AS TIME)  
			--then cast(ud.[initial_appt] as datetime)
		when ud.[initial_appt] between '1900-01-01' and '2079-06-06' and convert(time,isnull(ud.[appt_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(ud.[initial_appt] AS DATE) AS DATETIME) + CAST('00:00:00' AS TIME)  
		else '1900-01-01'
		end							as [FromDate]
    ,'1900-01-01'					as [ToDate]
	,(
		select ID
		from [sma_MST_CalendarAppointmentType]
		where AppointmentType='Case-related'
	)								as [AppointmentTypeID]
	,(
		select attnActivityTypeID
		from [sma_MST_ActivityType] 
		where attnActivityCtg = (
								select atcnPKId
								from sma_MST_ActivityCategory
								where atcsDscrptn='Case-Related Appointment'
								) 
		and attsDscrptn = 'Initial Appt'
	)							as [ActivityTypeID]
	,CAS.casnCaseID				as [CaseID]
	,null						as [LocationContactID]
	,2							as [LocationContactGtgID]
	,null						as [JudgeID]
	,null						as [Comments]
	,(
		select [StatusId]
		from [sma_MST_AppointmentStatus]
		where [StatusName]='Open'
	)							as [StatusID]
	,null						as [Address]
	,'Appointment'				as [Subject]
	,null						as [RecurranceParentID]
	,null						as [AdjournedID]
	,368						as [RecUserID]
	,getdate()					as [DtCreated]
	,null						as [ModifyUserID]
	,null						as [DtModified]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
--	,'Case-related:'+convert(varchar,CAL.calendar_id)	as [saga]
	,null						as [saga]
from NeedlesKMY..user_case_data ud
	join sma_TRN_Cases cas
		on cas.cassCaseNumber = ud.casenum
	JOIN CalendarJudgeStaffCourt MAP
		on MAP.CaseID=cas.casnCaseID
where isnull(ud.Initial_Appt,'') <> ''
GO



/* ####################################
user_case_data Pass 2
- appt_date -> start date
- appt_location -> address (no contact card available)
- appointment type = "Appointment"
*/

-- Create calendar appointments
insert into [sma_TRN_CalendarAppointments]
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
select 
	case
		when ud.[appt_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(ud.[appt_time],'00:00:00')) <> convert(time,'00:00:00')  
			then CAST(CAST(ud.[appt_date] AS DATE) AS DATETIME) + CAST(ud.[appt_time] AS TIME)  
			--then cast(ud.[appt_date] as datetime)
		when ud.[appt_date] between '1900-01-01' and '2079-06-06' and convert(time,isnull(ud.[appt_time],'00:00:00')) = convert(time,'00:00:00')  
			then CAST(CAST(ud.[appt_date] AS DATE) AS DATETIME) + CAST('00:00:00' AS TIME)  
		else '1900-01-01'
		end							as [FromDate]
    ,'1900-01-01'					as [ToDate]
	,(
		select ID
		from [sma_MST_CalendarAppointmentType]
		where AppointmentType='Case-related'
	)								as [AppointmentTypeID]
	,(
		select attnActivityTypeID
		from [sma_MST_ActivityType] 
		where attnActivityCtg = (
								select atcnPKId
								from sma_MST_ActivityCategory
								where atcsDscrptn='Case-Related Appointment'
								) 
			and attsDscrptn = 'Appointment'
	)							as [ActivityTypeID]
	,CAS.casnCaseID				as [CaseID]
	,null						as [LocationContactID]
	,null						as [LocationContactGtgID]
	,null						as [JudgeID]
	,null						as [Comments]
	,(
		select [StatusId]
		from [sma_MST_AppointmentStatus]
		where [StatusName]='Open'
	)							as [StatusID]
	,ud.Location				as [Address]
	,'Appointment'				as [Subject]
	,null						as [RecurranceParentID]
	,null						as [AdjournedID]
	,368						as [RecUserID]
	,getdate()					as [DtCreated]
	,null						as [ModifyUserID]
	,null						as [DtModified]
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null
	,null						as [saga]
--	,'Case-related:'+convert(varchar,CAL.calendar_id)	as [saga]
from NeedlesKMY..user_case_data ud
	join sma_TRN_Cases cas
		on cas.cassCaseNumber = ud.casenum
	JOIN CalendarJudgeStaffCourt MAP
		on MAP.CaseID=cas.casnCaseID
where isnull(ud.Appt_Date,'') <> ''
GO

                
---

alter table [sma_TRN_CalendarAppointments] enable trigger all

----(2)-----
INSERT INTO [sma_trn_AppointmentStaff]
(
	[AppointmentId]
	,[StaffContactId]
) 
select
	APP.AppointmentID
	,MAP.Staff_Contact 
FROM [sma_TRN_CalendarAppointments] APP
	JOIN NeedlesKMY.[dbo].[calendar] CAL
		on APP.saga='Case-related:'+convert(varchar,CAL.calendar_id)
	JOIN CalendarJudgeStaffCourt MAP
		on MAP.CalendarId=CAL.calendar_id


/*
----(3)-----
insert into [SA].[dbo].[sma_trn_AppointmentStaff] ( [AppointmentId] ,[StaffContactId] ) 
select APP.AppointmentID, MAP.Party_Contact
from [SA].[dbo].[sma_TRN_CalendarAppointments] APP
inner join NeedlesKMY.[dbo].[calendar] CAL on APP.saga='Case-related:'+convert(varchar,CAL.calendar_id)
inner join CalendarJudgeStaffCourt MAP on MAP.CalendarId=CAL.calendar_id
*/
