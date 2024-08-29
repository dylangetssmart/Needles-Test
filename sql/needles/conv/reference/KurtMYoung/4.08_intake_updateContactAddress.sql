USE SANeedlesKMY
GO

/*
--CHECK FOR SSN
select prefix, suffix, sex, Date_of_Birth, Ss_Number
from NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
where isnull(ss_number,'') <> ''
and isnull(ind.cinsSSNNo, '') = ''

--CHECK FOR DOB
select prefix, suffix, sex, Date_of_Birth, Ss_Number
from NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
where isnull(Date_of_Birth,'') <> ''
and isnull(ind.cindBirthDate, '') = ''

--CHECK FOR SEX
select prefix, suffix, sex, Date_of_Birth, Ss_Number
from NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
where isnull(sex,'') <> ''
and isnull(ind.cinnGender, '') = ''
*/
ALTER TABLE sma_mst_Indvcontacts
ALTER COLUMN cinsNickName varchar(50)
go


---------------------------------------------------------
--UPDATE SSN, DOD, DOB & SEX IF NOT ALREADY IN INDVCONTACTS
---------------------------------------------------------
UPDATE ind
SET cinsSSNNo = ss_number
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
WHERE isnull(ss_number,'') <> ''
and isnull(ind.cinsSSNNo, '') = ''

-- UPDATE ind
-- SET cindDateOfDeath = Date_of_Death
-- FROM NeedlesKMY..case_intake c
-- JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
-- JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
-- WHERE isnull(Date_of_Death,'') <> ''
-- and isnull(ind.cindDateOfDeath, '') = ''

UPDATE ind
SET cindBirthDate = Date_of_Birth
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
WHERE isnull(Date_of_Birth,'') <> ''
and isnull(ind.cindBirthDate, '') = ''

UPDATE ind
SET cinnGender = case when [sex]='M' then 1
					when [sex]='F' then 2 end
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
WHERE isnull(sex,'') <> ''
and isnull(ind.cinnGender, '') = ''

-- UPDATE ind
-- SET cinsNickName = 	isnull( nullif(convert(Varchar,AKA_First)+' ','') ,'') +
-- 				isnull( nullif(convert(Varchar,AKA_Last)+' ','') ,'') +
-- 				isnull( nullif(convert(Varchar,AKA_Role_Party)+' ','') ,'') + ''
-- FROM NeedlesKMY..case_intake c
-- JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
-- JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
-- WHERE (isnull(AKA_First,'') <> '' or isnull(aka_last,'') <>'' or isnull(aka_role_party,'') <> '')
-- and isnull(ind.cinsNickName, '') = ''

-------------------------------------------
--UPDATE SUBCATEGORY MINOR OR DECEASED
-------------------------------------------
-- UPDATE ind
-- SET [cinnContactSubCtgID] = (Select cscncontactSubCtgID FROM sma_MST_contactSubCategory where cscsDscrptn = 'Infant')
-- --select minor, [cinnContactSubCtgID]
-- FROM NeedlesKMY..case_intake c
-- JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
-- JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
-- WHERE isnull(minor,'') = 'Y'
-- and [cinnContactSubCtgID] <> (Select cscncontactSubCtgID FROM sma_MST_contactSubCategory where cscsDscrptn = 'Infant')

-- UPDATE ind
-- SET [cinnContactSubCtgID] = (Select cscncontactSubCtgID FROM sma_MST_contactSubCategory where cscsDscrptn = 'Deceased')
-- --select Deceased, [cinnContactSubCtgID]
-- FROM NeedlesKMY..case_intake c
-- JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
-- JOIN sma_MST_IndvContacts ind on ind.cinnContactID= ioc.cid and ind.cinnContactCtg = ioc.CTG
-- WHERE isnull(Deceased,'') = 'Y'
-- and [cinnContactSubCtgID] <> (Select cscncontactSubCtgID FROM sma_MST_contactSubCategory where cscsDscrptn = 'Deceased')


-------------------------------------------------------------------
--INSERT ADDRESSES THAT DO NOT MATCH WHAT IS ALREADY IN CONTACTS
-------------------------------------------------------------------
INSERT INTO [sma_MST_Address]
	(
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
	)
SELECT 
		Ioc.Ctg				as addnContactCtgID,
		ioc.CID				as addnContactID,
		T.addnAddTypeID		as addnAddressTypeID, 
		T.addsDscrptn		as addsAddressType,
		T.addsCode			as addsAddTypeCode,
		c.home_address		as addsAddress1,
		c.home_address_2	as addsAddress2,
		NULL				as addsAddress3,
		c.home_state		as addsStateCode,
		c.home_city			as addsCity,
		NULL				as addnZipID,
		c.home_zipcode		as addsZip,
		c.home_county		as addsCounty,
		c.home_country		as addsCountry,
		null				as addbIsResidence,
		0					as addbPrimary,
		null,null,null,null,null,null,
		''					as [addsComments],
		null,null,
		368					as addnRecUserID,
		getdate()			as adddDtCreated,
		368					as addnModifyUserID,
		getdate()			as adddDtModified,
		null,null,null,null,null
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_Address a on a.addnContactID = ioc.cid and a.addnContactCtgID = ioc.CTG and a.addsAddress1 = home_address
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = ioc.CTG and T.addsCode='HM'
WHERE isnull(home_address,'') <> '' 
and a.addnAddressID IS NULL

----------------------------------------------
--BUSINESS ADDRESSES
----------------------------------------------
INSERT INTO [sma_MST_Address]
	(
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
	)
SELECT 
		Ioc.Ctg				as addnContactCtgID,
		ioc.CID				as addnContactID,
		T.addnAddTypeID		as addnAddressTypeID, 
		T.addsDscrptn		as addsAddressType,
		T.addsCode			as addsAddTypeCode,
		c.business_address		as addsAddress1,
		c.business_address_2	as addsAddress2,
		NULL				as addsAddress3,
		c.business_state		as addsStateCode,
		c.business_city			as addsCity,
		NULL				as addnZipID,
		c.business_zipcode		as addsZip,
		c.business_county		as addsCounty,
		c.business_country		as addsCountry,
		null				as addbIsResidence,
		0					as addbPrimary,
		null,null,null,null,null,null,
		''					as [addsComments],
		null,null,
		368					as addnRecUserID,
		getdate()			as adddDtCreated,
		368					as addnModifyUserID,
		getdate()			as adddDtModified,
		null,null,null,null,null
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_Address a on a.addnContactID = ioc.cid and a.addnContactCtgID = ioc.CTG and a.addsAddress1 = business_address
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = ioc.CTG and T.addsDscrptn = 'Office' 
WHERE isnull(business_address,'') <> '' 
and a.addnAddressID IS NULL


-----------------------------------------
--INSERT EMAIL IF NOT ALREADY EXISTS
-----------------------------------------
 INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
 SELECT DISTINCT
		ioc.CTG				as cewnContactCtgID,
		ioc.CID				as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		c.home_email		as cewsEmailWebSite,
		1					as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		NULL				as saga -- indicate email
--select c.Home_Email
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_EmailWebsite e on e.cewnContactID = ioc.cid and e.cewnContactCtgID = ioc.ctg and c.Home_Email = e.cewsEmailWebSite
WHERE cewsEmailWebsiteFlag = 'E'
and isnull(c.Home_Email, '') <> ''
and e.cewnEmlWSID IS NULL


--BUSINESS EMAIL
 INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
 SELECT DISTINCT
		ioc.CTG				as cewnContactCtgID,
		ioc.CID				as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		c.business_email	as cewsEmailWebSite,
		NULL				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		NULL				as saga -- indicate email
--select c.business_email
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_EmailWebsite e on e.cewnContactID = ioc.cid and e.cewnContactCtgID = ioc.ctg and c.Business_Email = e.cewsEmailWebSite
WHERE cewsEmailWebsiteFlag = 'E'
and isnull(c.business_email, '') <> ''
and e.cewnEmlWSID IS NULL

-------------------------
--PHONE NUMBERS
-------------------------
INSERT INTO [sma_MST_ContactNumbers] (     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo] )
 SELECT 
		ioc.CTG					as cnnnContactCtgID,
		ioc.CID					as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Primary Phone' and ctynContactCategoryID=ioc.CTG) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(c.home_phone)	as cnnsContactNumber,
		null					as cnnsExtension,
		case when isnull(c.mobile_phone,'') = '' then 1 else 0 end		as cnnbPrimary,
		null					as cnnbVisible,
		ioc.AID					as cnnnAddressID,
		'Home Phone'			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
--SELECT c.home_phone,dbo.FormatPhone(c.home_phone)
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_ContactNumbers cn on cn.cnnnContactID = ioc.CID and cn.cnnnContactCtgID = ioc.CTG and cnnsContactNumber = dbo.FormatPhone(c.home_phone)
WHERE isnull(c.home_phone,'') <> ''
and cn.cnnnContactNumberID IS NULL


INSERT INTO [sma_MST_ContactNumbers] (     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo] )
 SELECT 
		ioc.CTG					as cnnnContactCtgID,
		ioc.CID					as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Cell' and ctynContactCategoryID=ioc.CTG) as cnnnPhoneTypeID,   
		dbo.FormatPhone(c.mobile_phone)	as cnnsContactNumber,
		null					as cnnsExtension,
		1						as cnnbPrimary,
		null					as cnnbVisible,
		ioc.AID					as cnnnAddressID,
		'Cell Phone'			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
--SELECT c.mobile_phone,dbo.FormatPhone(c.mobile_phone)
FROM NeedlesKMY..case_intake c
JOIN IndvOrgContacts_Indexed ioc on ioc.saga = c.name_id
LEFT JOIN sma_MST_ContactNumbers cn on cn.cnnnContactID = ioc.CID and cn.cnnnContactCtgID = ioc.CTG and cnnsContactNumber = dbo.FormatPhone(c.mobile_phone)
WHERE isnull(c.mobile_phone,'') <> ''
and cn.cnnnContactNumberID IS NULL


