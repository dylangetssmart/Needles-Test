
-- USE [SANeedlesSLF]
GO
/*
alter table [sma_MST_ContactNumbers] disable trigger all
delete from [sma_MST_ContactNumbers] 
DBCC CHECKIDENT ('[sma_MST_ContactNumbers]', RESEED, 0);
alter table [sma_MST_ContactNumbers] enable trigger all
*/


---(0)---
INSERT INTO sma_MST_ContactNoType ( ctysDscrptn,ctynContactCategoryID, ctysDefaultTexting )
SELECT 'Work Phone',1, 0
UNION
SELECT 'Work Fax',1, 0
UNION
SELECT 'Cell Phone',1, 0
EXCEPT
SELECT ctysDscrptn,ctynContactCategoryID, ctysDefaultTexting FROM sma_MST_ContactNoType 


---(0)----
IF OBJECT_ID (N'dbo.FormatPhone', N'FN') IS NOT NULL
    DROP FUNCTION FormatPhone;
GO
CREATE FUNCTION dbo.FormatPhone(@phone varchar(MAX) )
RETURNS varchar(MAX) 
AS 
BEGIN
    if len(@phone)=10 and ISNUMERIC(@phone)=1 
    begin
	   return '(' + Substring(@phone,1,3) + ') ' + Substring(@phone,4,3) + '-' + Substring(@phone,7,4) ---> this is good for perecman
    end
    return @phone;
END;
GO

---
ALTER TABLE [sma_MST_ContactNumbers] DISABLE TRIGGER ALL
---

INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg			as cnnnContactCtgID,
		C.cinnContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Primary Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(home_phone)	as cnnsContactNumber,
		home_ext					as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Home Phone'				as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(N.home_phone,'') <> ''  


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg			as cnnnContactCtgID,
		C.cinnContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Work Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Work Phone 
		dbo.FormatPhone(work_phone)	as cnnsContactNumber,
		work_extension				as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Work Phone'				as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(work_phone,'') <> ''
 

INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg			as cnnnContactCtgID,
		C.cinnContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Cell Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Cell Phone 
		dbo.FormatPhone(car_phone)	as cnnsContactNumber,
		car_ext						as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Mobile Phone'				as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1
WHERE isnull(car_phone,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg			as cnnnContactCtgID,
		C.cinnContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Primary Fax' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Cell Phone 
		dbo.FormatPhone(fax_number)	as cnnsContactNumber,
		fax_ext						as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Fax'						as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1
WHERE isnull(fax_number,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg			    as cnnnContactCtgID,
		C.cinnContactID					as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Cell Phone 
		dbo.FormatPhone(beeper_number)  as cnnsContactNumber,
		beeper_ext						as cnnsExtension,
		1								as cnnbPrimary,
		null						    as cnnbVisible,
		A.addnAddressID					as cnnnAddressID,
		'Pager'							as cnnsLabelCaption,
		368								as cnnnRecUserID,
		getdate()					    as cnndDtCreated,
	     368						    as cnnnModifyUserID,
		getdate()					    as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1
WHERE isnull(beeper_number,'') <> ''


 
INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg			as cnnnContactCtgID,
		C.connContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(home_phone)	as cnnsContactNumber,
		home_ext					as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Home'						as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null 
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(home_phone,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg			as cnnnContactCtgID,
		C.connContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='HQ/Main Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(work_phone)	as cnnsContactNumber,
		work_extension				as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Business'					as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF]..[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(work_phone,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg			as cnnnContactCtgID,
		C.connContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Cell' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(car_phone)	as cnnsContactNumber,
		car_ext						as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Mobile'					as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(car_phone,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg			as cnnnContactCtgID,
		C.connContactID				as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Fax' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(fax_number)	as cnnsContactNumber,
		fax_ext						as cnnsExtension,
		1							as cnnbPrimary,
		null						as cnnbVisible,
		A.addnAddressID				as cnnnAddressID,
		'Fax'						as cnnsLabelCaption,
		368							as cnnnRecUserID,
		getdate()					as cnndDtCreated,
		368							as cnnnModifyUserID,
		getdate()					as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(fax_number,'') <> ''


INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg			    as cnnnContactCtgID,
		C.connContactID					as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='HQ/Main Office Fax' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(beeper_number)  as cnnsContactNumber,
		beeper_ext						as cnnsExtension,
		1								as cnnbPrimary,
		null						    as cnnbVisible,
		A.addnAddressID					as cnnnAddressID,
		'Pager'							as cnnsLabelCaption,
		368								as cnnnRecUserID,
		getdate()					    as cnndDtCreated,
		368								as cnnnModifyUserID,
		getdate()					    as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
where isnull(beeper_number,'') <> ''
 

  
 ---(Appendix) Finally, only one phone number as primary---
UPDATE [sma_MST_ContactNumbers] set cnnbPrimary=0
FROM (
	SELECT 
		ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID )  as RowNumber,
		cnnnContactNumberID as ContactNumberID  
	FROM [sma_MST_ContactNumbers] 
	WHERE cnnnContactCtgID = (select ctgnCategoryID FROM [dbo].[sma_MST_ContactCtg] where ctgsDesc='Individual')
) A
WHERE A.RowNumber <> 1
and A.ContactNumberID=cnnnContactNumberID


UPDATE [sma_MST_ContactNumbers] set cnnbPrimary=0
FROM (
	SELECT 
		ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID )  as RowNumber,
		cnnnContactNumberID as ContactNumberID  
	FROM [sma_MST_ContactNumbers] 
	WHERE cnnnContactCtgID = (select ctgnCategoryID FROM [dbo].[sma_MST_ContactCtg] where ctgsDesc='Organization')
) A
WHERE A.RowNumber <> 1
and A.ContactNumberID=cnnnContactNumberID

---
ALTER TABLE [sma_MST_ContactNumbers] ENABLE TRIGGER ALL
--- 

----------------------
---(Other phones for Individual)--
--(1)-- 
INSERT INTO [sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg		as cnnnContactCtgID,
		C.cinnContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(other_phone1)	as cnnsContactNumber,
		other1_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title1			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN[sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
 where isnull(N.other_phone1,'') <> ''


--(2)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg		as cnnnContactCtgID,
		C.cinnContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(other_phone2)	as cnnsContactNumber,
		other2_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title2			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(N.other_phone2,'') <> ''

--(3)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg		as cnnnContactCtgID,
		C.cinnContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(other_phone3)	as cnnsContactNumber,
		other3_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title3			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(N.other_phone3,'') <> ''


--(4)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg		as cnnnContactCtgID,
		C.cinnContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(other_phone4)	as cnnsContactNumber,
		other4_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title4			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(N.other_phone4,'') <> ''


--(5)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.cinnContactCtg		as cnnnContactCtgID,
		C.cinnContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Home Vacation Phone' and ctynContactCategoryID=1) as cnnnPhoneTypeID,   -- Home Phone 
		dbo.FormatPhone(other_phone5)	as cnnsContactNumber,
		other5_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title5			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.cinnContactID and A.addnContactCtgID=C.cinnContactCtg and A.addbPrimary=1 
WHERE isnull(N.other_phone5,'') <> ''




--(Org 1)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg		as cnnnContactCtgID,
		C.connContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(other_phone1)	as cnnsContactNumber,
		other1_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title1			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(other_phone1,'') <> ''

--(Org 2)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg		as cnnnContactCtgID,
		C.connContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(other_phone2)	as cnnsContactNumber,
		other2_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title2			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(other_phone2,'') <> ''

--(Org 3)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg		as cnnnContactCtgID,
		C.connContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(other_phone3)	as cnnsContactNumber,
		other3_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title3			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(other_phone3,'') <> ''

--(Org 4)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg		as cnnnContactCtgID,
		C.connContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(other_phone4)	as cnnsContactNumber,
		other4_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title4			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(other_phone4,'') <> ''


--(Org 5)--
INSERT INTO [dbo].[sma_MST_ContactNumbers]
(     
       [cnnnContactCtgID],[cnnnContactID],[cnnnPhoneTypeID],[cnnsContactNumber],[cnnsExtension],[cnnbPrimary],[cnnbVisible],[cnnnAddressID],[cnnsLabelCaption]
	   ,[cnnnRecUserID],[cnndDtCreated],[cnnnModifyUserID],[cnndDtModified],[cnnnLevelNo],[caseNo]
)
SELECT 
		C.connContactCtg		as cnnnContactCtgID,
		C.connContactID			as cnnnContactID,
		(select ctynContactNoTypeID from sma_MST_ContactNoType where ctysDscrptn='Office Phone' and ctynContactCategoryID=2 ) as cnnnPhoneTypeID,   -- Office Phone 
		dbo.FormatPhone(other_phone5)	as cnnsContactNumber,
		other5_ext				as cnnsExtension,
		0						as cnnbPrimary,
		null					as cnnbVisible,
		A.addnAddressID			as cnnnAddressID,
		phone_title5			as cnnsLabelCaption,
		368						as cnnnRecUserID,
		getdate()				as cnndDtCreated,
		368						as cnnnModifyUserID,
		getdate()				as cnndDtModified,
		null,null
FROM [NeedlesSLF].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
JOIN [sma_MST_Address] A on A.addnContactID=C.connContactID and A.addnContactCtgID=C.connContactCtg and A.addbPrimary=1
WHERE isnull(other_phone5,'') <> ''
