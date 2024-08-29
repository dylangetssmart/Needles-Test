use [SANeedlesKMY]
go
/*
alter table [sma_TRN_PoliceReports] disable trigger all
delete from [sma_TRN_PoliceReports]
DBCC CHECKIDENT ('[sma_TRN_PoliceReports]', RESEED, 0);
alter table [sma_TRN_PoliceReports] enable trigger all

*/

---
ALTER TABLE [sma_TRN_PoliceReports] DISABLE TRIGGER ALL
GO
---

---(0)---
IF EXISTS (select * from sys.objects where [name]='Officer_Helper' and type='U')
BEGIN
	DROP TABLE Officer_Helper
END 
GO

CREATE TABLE Officer_Helper (
	OfficerCID int,
	OfficerCTG int,
	OfficerAID int,
	cinsGrade varchar(400)
)
GO
----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_Officer_Helper ON [Officer_Helper] (cinsGrade);   
----
GO
---(0)---
INSERT INTO Officer_Helper ( OfficerCID,OfficerCTG,OfficerAID,cinsGrade )
SELECT DISTINCT 
	I.cinnContactID	   as OfficerCID,
	I.cinnContactCtg	   as OfficerCTG,
	A.addnAddressID	   as OfficerAID, 
	I.cinsGrade
FROM NeedlesKMY.[dbo].[police] P
JOIN [sma_MST_IndvContacts] I on I.cinsGrade=P.officer and I.cinsPrefix='Officer' 
JOIN [sma_MST_Address] A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg and A.addbPrimary=1 

GO

DBCC DBREINDEX('Officer_Helper',' ',90)  WITH NO_INFOMSGS 


---(0)---
IF EXISTS (select * from sys.objects where name='Police_Helper' and type='U')
BEGIN
	DROP TABLE Police_Helper
END 
GO

CREATE TABLE Police_Helper (
	PoliceCID		int,
	PoliceCTG		int,
	PoliceAID		int,
	police_id		int,
	case_num		int,
	casnCaseID	int,	
	officerCID	int,
	officerAID	int
)
GO
----
CREATE NONCLUSTERED INDEX IX_NonClustered_Index_Police_Helper ON [Police_Helper] (police_id);   
----
GO

INSERT INTO Police_Helper 
(
	PoliceCID,
	PoliceCTG,
	PoliceAID,
	police_id,
	case_num,
	casnCaseID,
	officerCID,
	officerAID
)
SELECT 
	IOC.CID		    as PoliceCID,
	IOC.CTG		    as PoliceCTG,
	IOC.AID		    as PoliceAID,
	P.police_id	    as police_id,
	P.case_num,
	CAS.casnCaseID	    as casnCaseID,
	( select H.OfficerCID from Officer_Helper H where H.cinsGrade =P.officer ) as officerCID,
	( select H.OfficerAID from Officer_Helper H where H.cinsGrade =P.officer )	as officerAID
FROM NeedlesKMY.[dbo].[police] P
JOIN [sma_TRN_cases] CAS on CAS.cassCaseNumber=P.case_num
JOIN [IndvOrgContacts_Indexed] IOC on IOC.SAGA=P.police_id
GO

DBCC DBREINDEX('Police_Helper',' ',90)  WITH NO_INFOMSGS 
GO


---(2)---
INSERT INTO [sma_TRN_PoliceReports]
(
       [pornCaseID]
      ,[pornPoliceID]
      ,[pornPoliceAdID]
      ,[porsReportNo]
      ,[porsComments]
      ,[pornPOContactID]
      ,[pornPOCtgID]
      ,[pornPOAddressID]
)

SELECT 
    MAP.casnCaseID			as pornCaseID
    ,MAP.officerCID			as pornPoliceID
    ,MAP.officerAID			as pornPoliceAdID
    ,left(P.report_num,30)	as porsReportNo
    ,isnull('Badge:' + nullif(P.badge,'') +CHAR(13),'' )  
							as porsComments
    ,MAP.PoliceCID			as [pornPOContactID]
    ,MAP.PoliceCTG			as [pornPOCtgID]
    ,MAP.PoliceAID			as [pornPOAddressID]
FROM NeedlesKMY.[dbo].[police] P
JOIN Police_Helper MAP
	on MAP.police_id=P.police_id
		and MAP.case_num=P.case_num
GO

---
alter table [sma_TRN_PoliceReports] enable trigger all
GO
---


