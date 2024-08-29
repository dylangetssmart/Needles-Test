USE SANeedlesSLF
GO

/* ########################################################
1.0 - Create helper table
*/
CREATE TABLE Employer_Address_Helper (
    party_id INT,
    case_id INT,
    Employer NVARCHAR(255),
    Employers_Phone_Number NVARCHAR(50),
    Employers_Address NVARCHAR(255),
    City NVARCHAR(100),
    StateCode NVARCHAR(10),
    Zip NVARCHAR(10)
);

INSERT INTO Employer_Address_Helper
(
	party_id
	,case_id
	,Employer
	,Employers_Phone_Number
	,Employers_Address
	,City
	,StateCode
	,Zip
)
select
	party_id
	,case_id
	,Employer 
	,Employers_Phone_Number
	,Employers_Address
	,case
		when Employers_Address like '%,%,%,%'
			then reverse(substring(reverse(Employers_Address),  charindex(',',reverse(Employers_Address))+1, charindex(',',reverse(Employers_Address), charindex(',',reverse(Employers_Address))+1 ) - charindex(',',reverse(Employers_Address))-1 ) )
		when Employers_Address like '%,%,%'
			then substring(Employers_Address, charindex(',',Employers_Address)+1, charindex(',',Employers_Address, charindex(',',Employers_Address)+1 ) - charindex(',',Employers_Address)-1 ) 
		else ''
		end							as City
	,s.sttsCode						as StateCode
	,case
		when rtrim(Employers_Address) like '%[0-9][0-9][0-9][0-9][0-9]'
			then right(rtrim(Employers_Address),5) 
		when Employers_Address like '%[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
			then right(Employers_Address,10) 
		else ''
		end							as Zip
FROM needlesslf..user_party_data d
LEFT JOIN SANeedlesSLF..sma_MST_States s
	on Employers_Address like '% '+ s.sttsCode +' %' or Employers_Address like '%,'+ s.sttsCode +' %'
WHERE isnull(Employer,'') <> ''


/* ########################################################
2.0 - Create org contacts from case_intake.Employer_Name_Case
	- saga = case_id (actually case number)
	- create saga_ref field for another way to find these contacts
*/
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga_ref' AND Object_ID = Object_ID(N'sma_MST_OrgContacts'))
begin
    ALTER TABLE [sma_MST_OrgContacts] ADD [saga_ref] [varchar](100) NULL; 
end
GO

INSERT INTO [sma_MST_OrgContacts]
(
	[consName]
	,[connContactCtg]
	,[connContactTypeID]
	,[connRecUserID]
	,[condDtCreated]
	,[saga]
    ,[saga_ref]
)
SELECT 
	upd.Employer					as [consName]
	,2								as [connContactCtg]
	,(
		select octnOrigContactTypeID
		from [sma_MST_OriginalContactTypes]
		where octnContactCtgID=2 and octsDscrptn='General'
	)								as [connContactTypeID]
	,368							as [connRecUserID]
	,getdate()						as [condDtCreated]
	,upd.case_id					as [saga]
    ,'upd_employer'                 as [saga_ref]
from NeedlesSLF..user_party_data upd
where isnull(upd.Employer,'') <> ''


/* ########################################################
3.0 - Add address to the employer org contacts
*/
INSERT INTO [dbo].[sma_MST_Address]
(
	[addnContactCtgID]
	,[addnContactID]
	,[addnAddressTypeID]
	,[addsAddressType]
	,[addsAddTypeCode]
	,[addsAddress1]
	,[addsAddress2]
	,[addsAddress3]
	,[addsStateCode]
	,[addsCity]
	,[addnZipID]
	,[addsZip]
	,[addsCounty]
	,[addsCountry]
	,[addbIsResidence]
	,[addbPrimary]
	,[adddFromDate]
	,[adddToDate]
	,[addnCompanyID]
	,[addsDepartment]
	,[addsTitle]
	,[addnContactPersonID]
	,[addsComments]
	,[addbIsCurrent]
	,[addbIsMailing]
	,[addnRecUserID]
	,[adddDtCreated]
	,[addnModifyUserID]
	,[adddDtModified]
	,[addnLevelNo]
	,[caseno]
	,[addbDeleted]
	,[addsZipExtn]
	,[saga]
)
select
	org.connContactCtg			as addnContactCtgID
	,org.connContactID			as addnContactID
	,T.addnAddTypeID			as addnAddressTypeID
	,T.addsDscrptn				as addsAddressType
	,T.addsCode					as addsAddTypeCode
	,help.Employers_Address		as addsAddress1
	,null						as addsAddress2
	,NULL						as addsAddress3
	,help.StateCode				as addsStateCode
	,help.City					as addsCity
	,NULL						as addnZipID
	,help.Zip					as addsZip
	,null						as addsCounty
	,null						as addsCountry
	,null						as addbIsResidence
	,1 							as addbPrimary
	,null
	,null
	,null
	,null
	,null
	,null
	,null 						as [addsComments]
	,null
	,null
	,368						as addnRecUserID
	,getdate()					as adddDtCreated
	,368						as addnModifyUserID
	,getdate()					as adddDtModified
	,null as addnLevelNo
	,null as caseno
	,null as addbDeleted
	,null as addsZipExtn
	,null as saga
from NeedlesSLF..user_party_data upd
	join sma_MST_OrgContacts org
		on org.saga = upd.case_id
		and org.saga_ref = 'upd_employer'
	JOIN [sma_MST_AddressTypes] T
		on T.addnContactCategoryID = org.connContactCtg
		and T.addsCode='WRK'
	join Employer_Address_Helper help
		on help.case_id = upd.case_id
		and help.party_id = upd.party_id

where isnull(upd.Employers_Address,'') <> ''
GO


/* ########################################################
4.0 - Add phone number to the employer org contacts
*/
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
	[cnnnContactCtgID]
	,[cnnnContactID]
	,[cnnnPhoneTypeID]
	,[cnnsContactNumber]
	,[cnnsExtension]
	,[cnnbPrimary]
	,[cnnbVisible]
	,[cnnnAddressID]
	,[cnnsLabelCaption]
	,[cnnnRecUserID]
	,[cnndDtCreated]
	,[cnnnModifyUserID]
	,[cnndDtModified]
	,[cnnnLevelNo]
	,[caseNo]
)
SELECT 
		org.connContactCtg								as cnnnContactCtgID
		,org.connContactID								as cnnnContactID
		,(
			select ctynContactNoTypeID
			from sma_MST_ContactNoType
			where ctysDscrptn = 'Office Phone' and ctynContactCategoryID = 2
		) 												as cnnnPhoneTypeID
		,dbo.FormatPhone(help.Employers_Phone_Number)	as cnnsContactNumber
		,null											as cnnsExtension
		,1												as cnnbPrimary
		,null											as cnnbVisible
		,A.addnAddressID								as cnnnAddressID
		,null											as cnnsLabelCaption
		,368											as cnnnRecUserID
		,getdate()										as cnndDtCreated
		,368											as cnnnModifyUserID
		,getdate()										as cnndDtModified
		,null
		,null
FROM Employer_Address_Helper help
	 
	join sma_MST_OrgContacts org
		on org.saga = help.case_id
		and org.saga_ref = 'upd_employer'

	JOIN [sma_MST_Address] A
		on A.addnContactID = org.connContactID
		and A.addnContactCtgID = org.connContactCtg
		and A.addbPrimary = 1
WHERE isnull(help.Employers_Phone_Number,'') <> ''
		