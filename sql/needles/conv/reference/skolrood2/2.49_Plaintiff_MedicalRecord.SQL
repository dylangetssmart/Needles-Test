-- use SA
-- GO

/*
alter table [sma_TRN_Hospitals] disable trigger all
delete [sma_TRN_Hospitals]
DBCC CHECKIDENT ('[sma_TRN_Hospitals]', RESEED, 0);
alter table [sma_TRN_Hospitals] enable trigger all


alter table [sma_trn_MedicalProviderRequest] disable trigger all
delete [sma_trn_MedicalProviderRequest]
DBCC CHECKIDENT ([sma_trn_MedicalProviderRequest]', RESEED, 0);
alter table [sma_trn_MedicalProviderRequest] enable trigger all

*/
------------------------------------
--ADD SAGA BILL ID TO SP DAMAGES
------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga_bill_id' AND Object_ID = Object_ID(N'sma_TRN_SpDamages'))
BEGIN
    ALTER TABLE [sma_TRN_SpDamages] 
	ADD [saga_bill_id] [varchar](100) NULL; 
END
GO
------------------------------------
--ADD SAGA TO VISITS
------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Visits'))
BEGIN
    ALTER TABLE [sma_TRN_Visits] 
	ADD [saga] [varchar](100) NULL; 
END
GO

------------------------------------
--ADD SAGA TO HOSPITALS TABLE
------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_Hospitals'))
BEGIN
    ALTER TABLE [sma_TRN_Hospitals] 
	ADD [saga] [varchar](100) NULL; 
END

------------------------------------
--ADD SAGA TO MEDICAL REQUESTS TABLE
------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_trn_MedicalProviderRequest'))
BEGIN
    ALTER TABLE [sma_trn_MedicalProviderRequest] 
	ADD [saga] [varchar](100) NULL; 
END

/* RECORD REQUEST TYPES -----------------------------------------------------------------------
- Update num_assigned with the mini_dir_id of the applicable mini directory
*/
-- Create a temporary table to store record types
CREATE TABLE #recordTypes (
    Type_of_Record VARCHAR(255)
);

-- Insert the required record types into the temporary table
INSERT INTO #recordTypes (Type_of_Record)
SELECT DISTINCT code
FROM  [NeedlesSLF].[dbo].[mini_general_dir]
WHERE num_assigned = 41; -- update this value accordingly

-- Insert into sma_MST_Request_RecordTypes from the temporary table
INSERT INTO [sma_MST_Request_RecordTypes] (RecordType)
SELECT DISTINCT Type_of_Record
FROM  [NeedlesSLF].[dbo].[user_tab2_data] D
WHERE D.Type_of_Record IN (SELECT Type_of_Record FROM #recordTypes)
EXCEPT 
SELECT RecordType 
FROM [sma_MST_Request_RecordTypes];

-- -- Get the list of Type_of_Record values
-- DECLARE @recordTypes TABLE (Type_of_Record VARCHAR(255));

-- INSERT INTO @recordTypes (Type_of_Record)
-- SELECT DISTINCT code
-- FROM [NeedlesSLF].[dbo].[mini_general_dir]
-- WHERE num_assigned = 41; -- update this value

-- -- Insert into sma_MST_Request_RecordTypes
-- INSERT INTO sma_MST_Request_RecordTypes (RecordType)
-- SELECT DISTINCT Type_of_Record
-- FROM [NeedlesSLF].[dbo].[user_tab2_data] D
-- WHERE d.Type_of_Record IN (SELECT Type_of_Record FROM @recordTypes)
-- EXCEPT 
-- SELECT RecordType 
-- FROM sma_MST_Request_RecordTypes;

-- INSERT INTO sma_MST_Request_RecordTypes
-- (
-- 	RecordType 
-- )
-- (
-- 	SELECT DISTINCT Type_of_Record
-- 	from [NeedlesSLF].[dbo].[user_tab2_data] D
-- 	WHERE d.Type_of_Record in ('Ambulance Bill', 'Ambulance Record', 'Anesthesiologist', 'Autopsy', 'Dental Bill', 'Dental Record', 'ER Bill', 'ER Record', 
-- 						'ER Physician Bill', 'Hospital Bill', 'Hospital Record', 'Hospital Bil&Rec', 'Medical Bill', 'Medical Record', 'Med Bill & Rec', 
-- 						'Narrative', 'Pharmacy', 'PT Bill/Rec', 'Radiology', 'Affidavit', '714 Req bill', 'Prior Records', '714 Unpaid ltr', '714 Bill carrier ltr', 
-- 						'714 Ltr to carrier to pay bill', '714 Paid ltr', '714 Order to VWC', '714 HI Req printout', '714 HI Unpaid ltr', '714 HI Ltr to provider to reimb HI', 
-- 						'714 HI Paid ltr', '714 Pay now ltr', 'Radiology Billing', 'Cancelled Request', 'Implant Log', 'Operation Report', 'APR' )
-- )
-- EXCEPT SELECT RecordType FROM sma_MST_Request_RecordTypes

------------------------------------
--REQUEST STATUS
------------------------------------
INSERT INTO sma_MST_RequestStatus ( Status, Description )
SELECT 'No Record Available','No Record Available'
EXCEPT
SELECT Status,Description FROM sma_MST_RequestStatus
GO


------------------------------------
--MEDICAL PROVIDER HELPER
------------------------------------
IF EXISTS (select * from sys.objects where name='user_tab2_MedicalProvider_Helper' and type='U')
BEGIN
	drop table user_tab2_MedicalProvider_Helper
END 
GO

---(0)---
CREATE TABLE user_tab2_MedicalProvider_Helper (
    TableIndex [int] IDENTITY(1,1) NOT NULL,
	case_id				int,
	tab_id				int,
	ProviderNameId		int,
	ProviderName		varchar(200),
	ProviderCID			int,
	ProviderCTG			int,
	ProviderAID			int,
	casnCaseID			int,
CONSTRAINT IOC_Clustered_Index_user_tab2_MedicalProvider_Helper PRIMARY KEY CLUSTERED ( TableIndex )
) ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_NonClustered_Index_user_tab2_MedicalProvider_Helper_case_id ON [user_tab2_MedicalProvider_Helper] (case_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_user_tab2_MedicalProvider_Helper_tab_id ON [user_tab2_MedicalProvider_Helper] (tab_id);   
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_user_tab2_MedicalProvider_Helper_ProviderNameId ON [user_tab2_MedicalProvider_Helper] (ProviderNameId);   
GO

---(0)---
INSERT INTO user_tab2_MedicalProvider_Helper (
	case_id
	,tab_id
	,ProviderNameId
	,ProviderName
	,ProviderCID
	,ProviderCTG
	,ProviderAID
	,casnCaseID
)
SELECT
    D.case_id			   as case_id,		
    D.tab_id			   as tab_id,		-- needles records TAB item
    N.[user_name]		   as ProviderNameId,  
    IOC.[Name]			   as ProviderName,
    IOC.CID				   as ProviderCID,  
    IOC.CTG				   as ProviderCTG,
    IOC.AID				   as ProviderAID,
    CAS.casnCaseID		   as casnCaseID  
FROM [NeedlesSLF].[dbo].[user_tab2_data] D
JOIN [NeedlesSLF].[dbo].[user_tab2_name] N
	on N.tab_id = D.tab_id
	and N.user_name <> 0
	and N.ref_num = (
						SELECT TOP 1 M.ref_num
						FROM [NeedlesSLF].[dbo].[user_tab2_matter] M
						WHERE M.field_title='Provider'
					)
JOIN [IndvOrgContacts_Indexed] IOC
	on IOC.SAGA = N.user_name
JOIN [sma_TRN_Cases] CAS
	on CAS.cassCaseNumber = D.case_id
where D.Type_of_Record IN (
							SELECT Type_of_Record 
							FROM #recordTypes
						)
-- WHERE D.Type_of_Record in ('Ambulance Bill', 'Ambulance Record', 'Anesthesiologist', 'Autopsy', 'Dental Bill', 'Dental Record', 'ER Bill', 'ER Record', 
-- 						'ER Physician Bill', 'Hospital Bill', 'Hospital Record', 'Hospital Bil&Rec', 'Medical Bill', 'Medical Record', 'Med Bill & Rec', 
-- 						'Narrative', 'Pharmacy', 'PT Bill/Rec', 'Radiology', 'Affidavit', '714 Req bill', 'Prior Records', '714 Unpaid ltr', '714 Bill carrier ltr', 
-- 						'714 Ltr to carrier to pay bill', '714 Paid ltr', '714 Order to VWC', '714 HI Req printout', '714 HI Unpaid ltr', '714 HI Ltr to provider to reimb HI', 
-- 						'714 HI Paid ltr', '714 Pay now ltr', 'Radiology Billing', 'Cancelled Request', 'Implant Log', 'Operation Report', 'APR' )
GO

---(0)---
DBCC DBREINDEX('user_tab2_MedicalProvider_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---
ALTER TABLE [sma_TRN_Hospitals] DISABLE TRIGGER ALL
GO
ALTER TABLE [sma_trn_MedicalProviderRequest] DISABLE TRIGGER ALL
GO
--alter table [sma_TRN_SpDamages] disable trigger all
--GO
--alter table [sma_TRN_Visits] disable trigger all
--GO

--------------------------------------------------------------------------
---------------------------- MEDICAL PROVIDERS ---------------------------
--------------------------------------------------------------------------
INSERT INTO [sma_TRN_Hospitals]
(
	[hosnCaseID]
	,[hosnContactID]
	,[hosnContactCtg]
	,[hosnAddressID]
	,[hossMedProType]
	,[hosdStartDt]
	,[hosdEndDt]
	,[hosnPlaintiffID]
	,[hosnComments]
	,[hosnHospitalChart]
	,[hosnRecUserID]
	,[hosdDtCreated]
	,[hosnModifyUserID]
	,[hosdDtModified]
	,[saga]
)
SELECT DISTINCT
    casnCaseID				as [hosnCaseID]
    ,ProviderCID			as [hosnContactID]
    ,ProviderCTG			as [hosnContactCtg]
    ,ProviderAID			as [hosnAddressID] 
    ,'M' 					as [hossMedProType]			--M or P (P for Prior Medical Provider)
    ,NULL 					as [hosdStartDt]
    ,NULL 					as [hosdEndDt]
    ,(
		select plnnPlaintiffID
		FROM [sma_TRN_Plaintiff]
		WHERE plnnCaseID = casnCaseID and plnbIsPrimary=1
	)						as hosnPlaintiffID
	,''						as [hosnComments]
	,null					as [hosnHospitalChart]
    ,368					as [hosnRecUserID]
    ,getdate()				as [hosdDtCreated]
    ,null					as [hosnModifyUserID]
    ,null					as [hosdDtModified]
    ,'tab2'					as [saga]
	--'tab2:'+convert(varchar,UD.tab_id)	as [saga]
FROM [NeedlesSLF].[dbo].[user_tab2_data] D
JOIN user_tab2_MedicalProvider_Helper MAP
	on MAP.case_id = D.case_id
	and MAP.tab_id=D.tab_id
LEFT JOIN [sma_TRN_Hospitals] H
	on H.hosnCaseID = MAP.casnCaseID
	and H.hosnContactID = MAP.ProviderCID
	and H.hosnContactCtg = MAP.ProviderCTG
	and H.hosnAddressID = MAP.ProviderAID 
WHERE H.hosnHospitalID is null	--only add the hospital if it does not already exist

--------------------------
--UPDATE TREATMENT ENDED
--------------------------
-- UPDATE sma_TRN_Hospitals
-- SET hosnTreatementEnded  = 0
-- FROM [NeedlesSLF].[dbo].[user_tab2_data] D
-- JOIN user_tab2_MedicalProvider_Helper MAP on MAP.case_id=D.case_id and MAP.tab_id=D.tab_id
-- JOIN [sma_TRN_Hospitals] H on H.hosnCaseID=MAP.casnCaseID and H.hosnContactID=MAP.ProviderCID and H.hosnContactCtg=MAP.ProviderCTG and H.hosnAddressID=MAP.ProviderAID 
-- WHERE d.Still_Treating = 'N'


/*
(
    SELECT		 
	   D.tab_id,
	   ROW_NUMBER() over(partition by MAP.ProviderCID,MAP.ProviderCTG,MAP.casnCaseID order by D.tab_id ) as RowNumber,
	   MAP.casnCaseID,
	   MAP.ProviderCID,
	   MAP.ProviderCTG,
	   MAP.ProviderAID
    FROM [NeedlesSLF].[dbo].[user_tab2_data] D
    JOIN user_tab2_MedicalProvider_Helper MAP on MAP.case_id=D.case_id and MAP.tab_id=D.tab_id
    LEFT JOIN [sma_TRN_Hospitals] H on H.hosnCaseID=MAP.casnCaseID and H.hosnContactID=MAP.ProviderCID and H.hosnContactCtg=MAP.ProviderCTG and H.hosnAddressID=MAP.ProviderAID 
    where H.hosnHospitalID is null --- Note: In case there are more than 1 needle TAB being mapped to Hospital, we want unique hospital
) A 
inner join [NeedlesSLF].[dbo].[user_tab2_data] UD on UD.tab_id=A.tab_id
where A.RowNumber=1
*/
--select * From user_tab2_MedicalProvider_Helper


--------------------------------------------------------------------------
---------------------------- MEDICAL REQUESTS ----------------------------
--------------------------------------------------------------------------

INSERT INTO [sma_trn_MedicalProviderRequest]
(
    MedPrvCaseID
    ,MedPrvPlaintiffID
    ,MedPrvhosnHospitalID
    ,MedPrvRecordType
    ,MedPrvRequestdate
    ,MedPrvAssignee
    ,MedPrvAssignedBy
	,MedPrvHighPriority
    ,MedPrvFromDate
    ,MedPrvToDate
    ,MedPrvComments
	,MedPrvNotes
    ,MedPrvCompleteDate
    ,MedPrvStatusId
    ,MedPrvFollowUpDate
	,MedPrvStatusDate
	,OrderAffidavit
	,FollowUpNotes		--Retrieval Provider Notes
	,SAGA
)
SELECT 
    hosnCaseID					 	as MedPrvCaseID
    ,hosnPlaintiffID				as MedPrvPlaintiffID
    ,H.hosnHospitalID				as MedPrvhosnHospitalID
    ,(
		select uId
		from sma_MST_Request_RecordTypes
		where RecordType = UD.Type_of_Record
	)								as MedPrvRecordType
    ,case
		when (UD.Date_Requested between '1900-01-01' and '2079-06-06')
			then UD.Date_Requested 
		else null
		end							as MedPrvRequestdate
    ,(
		select usrnUserID
		From sma_mst_users
		where saga = ud.Received_By
	)						 		as MedPrvAssignee
	,case
		when isnull(ud.Ordered_By,'') <> ''
			then (
					select usrnUserID
					From sma_mst_users
					where saga = ud.Ordered_By
				)
		when isnull(ud.Requested_By,'') <> ''
			then (
					select usrnUserID
					From sma_mst_users
					where saga = ud.Requested_By
				)
		else null
		end 						as MedPrvAssignedBy
    ,case
		when ud.Order_Immediately = 'Y'
			then 1
		else 0
		end					 		as MedPrvHighPriority		--1=high priority; 0=Normal
    ,case
		when (UD.For_Dates_From between '1900-01-01' and '2079-06-06')
			then UD.For_Dates_From
		else null
		end							as MedPrvFromDate
    ,case
		when (UD.Through between '1900-01-01' and '2079-06-06')
			then UD.Through
		else null
		end							as MedPrvToDate
    ,isnull('Comments: ' + NULLIF(convert(varchar(max),UD.Comments),'') + CHAR(13),'')
		+ isnull('Notes to Lexitas - ARC: ' + NULLIF(convert(varchar(max),UD.Notes_to_Lexitas__ARC),'') + CHAR(13),'')
		+ isnull('Method: ' + NULLIF(convert(varchar(max),ud.Method),'') + CHAR(13),'')
		+ isnull('Reason Cancelled: ' + NULLIF(convert(varchar(max),ud.Reason_Cancelled),'') + CHAR(13),'')
	 	+ ''						as MedPrvComments
	,isnull('Notes To Provider: ' + NULLIF(convert(varchar(max),ud.Notes_to_Provider),'') + CHAR(13),'')
									as MedPrvNotes
    ,case
		when (UD.Date_Received between '1900-01-01' and '2079-06-06')
			then UD.Date_Received
		else null
		end								as MedPrvCompleteDate
    ,case
		when (UD.Date_Received between '1900-01-01' and '2079-06-06')
			then (
					select uId
					from [sma_MST_RequestStatus]
					where [status]='Received'
				)
		when isnull(ud.Reason_Cancelled,'') <> ''
			then (
					select uId
					from [sma_MST_RequestStatus]
					where [status]='Canceled'
				)
		else null
		end								as MedPrvStatusId
    ,null								as MedPrvFollowUpDate
	,case
		when (UD.Date_Received between '1900-01-01' and '2079-06-06') 
			then (
					select uId
					from [sma_MST_RequestStatus]
					where [status]='Received'
				)
		else null
		end								as MedPrvStatusDate
	,case
		when ud.Order_Affidavit = 'Y'
			then 1
		else 0
		end 							as OrderAffidavit
	,isnull('Notes to Lexitas - ARC: ' + NULLIF(convert(varchar(max),UD.Lexitas_ARC_FollowUp_Note),'') + CHAR(13),'')
	+ ''											as FollowUpNotes	--Retreival Provider Notes
	,'tab2: '+ convert(varchar,UD.tab_id)			as SAGA
FROM [NeedlesSLF].[dbo].[user_tab2_data] UD
JOIN user_tab2_MedicalProvider_Helper MAP
	on MAP.case_id = UD.case_id
	and MAP.tab_id = UD.tab_id
JOIN [sma_TRN_Hospitals] H
	on H.hosnContactID = MAP.ProviderCID
	and H.hosnContactCtg = MAP.ProviderCTG
	and H.hosnCaseID = MAP.casnCaseID
GO


/*
--------------------------------------------------------------------------
------------------------------ MEDICAL VISITS -----------------------------
--------------------------------------------------------------------------
insert into  [SA].[dbo].[sma_TRN_Visits]
(
       [vissRefTable]
      ,[visnRecordID]
      ,[visdAdmissionDt]
      ,[visnAdmissionTypeID]
      ,[visdDischargeDt]
      ,[vissAccountNo]
	  ,[vissComplaint]
	  ,[vissDiagnosis]
      ,[visnRecUserID]
      ,[visdDtCreated]
      ,[visnModifyUserID]
      ,[visdDtModified]
	  ,[vissTreatmentPlan]
	  ,[vissComments]
)
select 
    'Hospitals'			  as [vissRefTable],
    H.hosnHospitalID	   as [visnRecordID],
    NULL				   as [visdAdmissionDt],
    (select amtnAdmsnTypeID from sma_MST_AdmissionType where amtsDscrptn='Office Visit')  as [visnAdmissionTypeID],
    NULL				   as [visdDischargeDt],
    NULL				   as [vissAccountNo],
    NULL				   as [vissComplaint],
    d.Findings			   as [vissDiagnosis],
    368					   as [visnRecUserID],
    getdate()			   as [visdDtCreated],
    NULL				   as [visnModifyUserID],
    NULL				   as [visdDtModified],
    D.Treatment_Received		   as [vissTreatmentPlan],
    null				   as [vissComments]
from [NeedlesSLF].[dbo].[user_tab2_data] D
inner join user_tab2_MedicalProvider_Helper MAP on MAP.tab_ID=D.tab_id
inner join [SA].[dbo].[sma_TRN_Hospitals] H on H.hosnCaseID=MAP.casnCaseID and H.hosnContactID=MAP.ProviderCID and H.hosnContactCtg=MAP.ProviderCTG and H.hosnAddressID=MAP.ProviderAID 
WHERE isnull(Treatment_Received,'')<> '' or
isnull(findings,'')<>''

--------------------------------------------------------------------------
------------------------------ MEDICAL BILLS -----------------------------
--------------------------------------------------------------------------
insert into [SA].[dbo].[sma_TRN_SpDamages]
(
     [spdsRefTable]
    ,[spdnRecordID]
    ,[spdnBillAmt]
    ,[spdsAccntNo]
    ,[spddNegotiatedBillAmt]
    ,[spddDateFrom]
    ,[spddDateTo]
    ,[spddDamageSubType]
    ,[spdnVisitId]
    ,[spdsComments]
    ,[spdnRecUserID]
    ,[spddDtCreated]
    ,[spdnModifyUserID]
    ,[spddDtModified]
    ,[spdnBalance]
    ,[spdbLienConfirmed]
    ,[spdbDocAttached]
    ,[saga_bill_id]
)
select 
    'Hospitals'			   as spdsRefTable,
    H.hosnHospitalID	   as spdnRecordID,
    convert(numeric(18, 2), D.Total_Bill_Amount)	as spdnBillAmt,
    NULL				   as spdsAccntNo,
    null				   as spddNegotiatedBillAmt,
    null				   as spddDateFrom,
    null				   as spddDateTo,
    null				   as spddDamageSubType,
    null				   as spdnVisitId, 
    isnull('SSA RFCs: ' + NULLIF(D.SSA_RFCs,'') + CHAR(13),'') + 
	isnull('Reason for 1''s: ' + NULLIF(convert(varchar,D.Reason_for_1s),'') + CHAR(13),'') + 
	isnull('Phone #: ' + NULLIF(convert(varchar,D.Phone_#),'') + CHAR(13),'') + 
	isnull('Final Outstanding Balance:' + NULLIF(convert(varchar,D.Final_Outstanding_Balance),'') + CHAR(13),'') + 
	isnull('Final Balance Confirmed:' + NULLIF(convert(varchar,D.Final_Balance_Confirmed),'') + CHAR(13),'') + 
	isnull('HITECH AUTH SENT:' + NULLIF(convert(varchar,D.HITECH_AUTH_SENT),'') + CHAR(13),'') + 
	isnull('HITECH VIOLATION:' + NULLIF(convert(varchar,D.HITECH_VIOLATION),'') + CHAR(13),'') + 
	isnull('HITECH VIOLATION LTR SENT:' + NULLIF(convert(varchar,D.HITECH_VIOLATION_LTR_SENT),'') + CHAR(13),'') + 
	isnull('HITECH VIOLATION F/U:' + NULLIF(convert(varchar,D.HITECH_VIOLATION_FU),'') + CHAR(13),'') + 
	isnull('HITECH Comments:' + NULLIF(D.HITECH_Comments,'') + CHAR(13),'') + 
	isnull('Req Confirmed with Prov.:' + NULLIF(convert(varchar,D.Req_Confirmed_with_Prov),'') + CHAR(13),'') + 
	''						as spdsComments,
    368						as spdnRecordID,
    getdate()				as spddDtCreated,
    null					as spdnModifyUserID,
    null				    as spddDtModified,
    null				    as spdnBalance,
    0						as spdbLienConfirmed,
    0						as spdbDocAttached,
    'tab2:' + convert(varchar,D.tab_id)	
							as saga_bill_id  -- one bill one value
from [NeedlesSLF].[dbo].[user_tab2_data] D
inner join user_tab2_MedicalProvider_Helper MAP on MAP.tab_id=D.tab_id
inner join [SA].[dbo].[sma_TRN_Hospitals] H on H.hosnCaseID=MAP.casnCaseID and H.hosnContactID=MAP.ProviderCID and H.hosnContactCtg=MAP.ProviderCTG and H.hosnAddressID=MAP.ProviderAID 


---(Appendix)--- Update hospital TotalBill from Bill section
UPDATE [sma_TRN_Hospitals]
SET hosnTotalBill = (SELECT SUM(spdnBillAmt) FROM sma_TRN_SpDamages WHERE sma_TRN_SpDamages.spdsRefTable='Hospitals' AND sma_TRN_SpDamages.spdnRecordID = hosnHospitalID)

UPDATE [sma_TRN_Hospitals]
SET hosnTotalMedicalVisits = (SELECT count(*) FROM sma_TRN_Visits WHERE sma_TRN_Visits.vissRefTable='Hospitals' AND sma_TRN_Visits.visnRecordID = hosnHospitalID)

*/


---
ALTER TABLE [sma_trn_MedicalProviderRequest] ENABLE TRIGGER ALL
GO
ALTER TABLE [sma_TRN_Hospitals] ENABLE TRIGGER ALL
GO
--alter table [sma_TRN_SpDamages] enable trigger all
--GO
--alter table [sma_TRN_Visits] enable trigger all
--GO



