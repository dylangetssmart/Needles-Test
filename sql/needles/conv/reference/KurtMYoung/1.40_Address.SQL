
USE [SANeedlesKMY]
GO
/*
alter table [sma_MST_Address] disable trigger all
delete from [sma_MST_Address] 
DBCC CHECKIDENT ('[sma_MST_Address]', RESEED, 0);
alter table [sma_MST_Address] enable trigger all
*/
-- select distinct addr_Type from  [NeedlesKMY].[dbo].[multi_addresses]
-- select * from  [NeedlesKMY].[dbo].[multi_addresses] where addr_type not in ('Home','business', 'other')

ALTER TABLE [sma_MST_Address] DISABLE TRIGGER ALL
GO

-----------------------------------------------------------------------------
----(1)--- CONSTRUCT SMA_MST_ADDRESS FROM EXISTING SMA_MST_INDVCONTACTS
-----------------------------------------------------------------------------
 
 -- Home from IndvContacts
 INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)
SELECT 
	I.cinnContactCtg		as addnContactCtgID,
	I.cinnContactID			as addnContactID,
	T.addnAddTypeID			as addnAddressTypeID, 
	T.addsDscrptn			as addsAddressType,
	T.addsCode				as addsAddTypeCode,
	A.[address]				as addsAddress1,
	A.[address_2]			as addsAddress2,
	NULL					as addsAddress3,
	A.[state]				as addsStateCode,
	A.[city]				as addsCity,
	NULL					as addnZipID,
	A.[zipcode]				as addsZip,
	A.[county]				as addsCounty,
	A.[country]				as addsCountry,
	null					as addbIsResidence,
	case 
		when A.[default_addr]='Y' then 1 
		else 0
	end						as addbPrimary,
	null,null,null,null,null,null,
	case
	  when isnull(A.company,'')<>'' then (
		'Company : ' + CHAR(13) + A.company
	  )
	  else '' 		    
	end						as [addsComments],
	null,null,
	368						as addnRecUserID,
	getdate()				as adddDtCreated,
	368						as addnModifyUserID,
	getdate()				as adddDtModified,
	null,null,null,null,null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Indvcontacts] I on I.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = I.cinnContactCtg and T.addsCode='HM'
WHERE (A.[addr_type]='Home' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   
 
 -- Business from IndvContacts
INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)
SELECT 
	I.cinnContactCtg		as addnContactCtgID,
	I.cinnContactID			as addnContactID,
	T.addnAddTypeID			as addnAddressTypeID, 
	T.addsDscrptn			as addsAddressType,
	T.addsCode				as addsAddTypeCode,
	A.[address]				as addsAddress1,
	A.[address_2]			as addsAddress2,
	NULL					as addsAddress3,
	A.[state]				as addsStateCode,
	A.[city]				as addsCity,
	NULL					as addnZipID,
	A.[zipcode]				as addsZip,
	A.[county]				as addsCounty,
	A.[country]				as addsCountry,
	null					as addbIsResidence,
	case 
		when A.[default_addr]='Y' then 1 
		else 0 
	end						as addbPrimary,
	null,
	null,
	null,
	null,
	null,
	null,
	case
		when isnull(A.company,'')<>'' then (
			'Company : ' + CHAR(13) + A.company
		)	
		else '' 		    
	end						as [addsComments],
	null,null,
	368						as addnRecUserID,
	getdate()				as adddDtCreated,
	368						as addnModifyUserID,
	getdate()				as adddDtModified,
	null,
	null,
	null,
	null,
	null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Indvcontacts] I on I.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = I.cinnContactCtg and T.addsCode='WORK'
WHERE (A.[addr_type]='Business' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   
 
-- Other from IndvContacts
INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)
SELECT 
	I.cinnContactCtg		as addnContactCtgID,
	I.cinnContactID			as addnContactID,
	T.addnAddTypeID			as addnAddressTypeID, 
	T.addsDscrptn			as addsAddressType,
	T.addsCode				as addsAddTypeCode,
	A.[address]				as addsAddress1,
	A.[address_2]			as addsAddress2,
	NULL					as addsAddress3,
	A.[state]				as addsStateCode,
	A.[city]				as addsCity,
	NULL					as addnZipID,
	A.[zipcode]				as addsZip,
	A.[county]				as addsCounty,
	A.[country]				as addsCountry,
	null					as addbIsResidence,
	case when A.[default_addr]='Y' then 1
		else 0
	end						as addbPrimary,
	null,
	null,
	null,
	null,
	null,
	null,
	case
	  when isnull(A.company,'')<>'' then (
			'Company : ' + CHAR(13) + A.company
		)
	  else '' 		    
	end						as [addsComments],
	null,
	null,
	368						as addnRecUserID,
	getdate()				as adddDtCreated,
	368						as addnModifyUserID,
	getdate()				as adddDtModified,
	null,
	null,
	null,
	null,
	null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Indvcontacts] I on I.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = I.cinnContactCtg and T.addsCode='OTH'
WHERE (A.[addr_type]='Other' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   
 

 -------------------------------------------------------
----(2)---- CONSTRUCT FROM SMA_MST_ORGCONTACTS
-------------------------------------------------------

-- Home from OrgContacts
INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)  
SELECT 
	O.connContactCtg		as addnContactCtgID,
	O.connContactID			as addnContactID,
	T.addnAddTypeID			as addnAddressTypeID, 
	T.addsDscrptn			as addsAddressType,
	T.addsCode				as addsAddTypeCode,
	A.[address]				as addsAddress1,
	A.[address_2]			as addsAddress2,
	NULL					as addsAddress3,
	A.[state]				as addsStateCode,
	A.[city]				as addsCity,
	NULL					as addnZipID,
	A.[zipcode]				as addsZip,
	A.[county]				as addsCounty,
	A.[country]				as addsCountry,
	null					as addbIsResidence,
	case
		when A.[default_addr]='Y' then 1
		else 0
	end						as addbPrimary,
	null,
	null,
	null,
	null,
	null,
	null,
	case
	  when isnull(A.company,'')<>'' then (
		'Company : ' + CHAR(13) + A.company
		)
	  else '' 		    
	end						as [addsComments],
	null,
	null,
	368						as addnRecUserID,
	getdate()				as adddDtCreated,
	368						as addnModifyUserID,
	getdate()				as adddDtModified,
	null,
	null,
	null,
	null,
	null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Orgcontacts] O on O.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = O.connContactCtg and T.addsCode='HO'
WHERE (A.[addr_type]='Home' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   

-- Business from OrgContacts
INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)
SELECT 
		O.connContactCtg	as addnContactCtgID,
		O.connContactID		as addnContactID,
		T.addnAddTypeID		as addnAddressTypeID, 
		T.addsDscrptn		as addsAddressType,
		T.addsCode			as addsAddTypeCode,
		A.[address]			as addsAddress1,
		A.[address_2]		as addsAddress2,
		NULL				as addsAddress3,
		A.[state]			as addsStateCode,
		A.[city]			as addsCity,
		NULL				as addnZipID,
		A.[zipcode]			as addsZip,
		A.[county]			as addsCounty,
		A.[country]			as addsCountry,
		null				as addbIsResidence,
		case when A.[default_addr]='Y' then 1 else 0 end as addbPrimary,
		null,null,null,null,null,null,
		case
		  when isnull(A.company,'')<>'' then 'Company : ' + CHAR(13) + A.company
		  else '' 		    
		end					as [addsComments],
		null,null,
		368					as addnRecUserID,
		getdate()			as adddDtCreated,
		368					as addnModifyUserID,
		getdate()			as adddDtModified,
		null,null,null,null,null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Orgcontacts] O on O.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = O.connContactCtg and T.addsCode='WRK'
WHERE (A.[addr_type]='Business' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   

-- Other from OrgContacts
INSERT INTO [sma_MST_Address] (
		[addnContactCtgID],[addnContactID],[addnAddressTypeID],[addsAddressType],[addsAddTypeCode],[addsAddress1],[addsAddress2],[addsAddress3],[addsStateCode],[addsCity],[addnZipID],
		[addsZip],[addsCounty],[addsCountry],[addbIsResidence],[addbPrimary],[adddFromDate],[adddToDate],[addnCompanyID],[addsDepartment],[addsTitle],[addnContactPersonID],[addsComments],
		[addbIsCurrent],[addbIsMailing],[addnRecUserID],[adddDtCreated],[addnModifyUserID],[adddDtModified],[addnLevelNo],[caseno],[addbDeleted],[addsZipExtn],[saga]
)
SELECT 
	O.connContactCtg		as addnContactCtgID,
	O.connContactID			as addnContactID,
	T.addnAddTypeID			as addnAddressTypeID, 
	T.addsDscrptn			as addsAddressType,
	T.addsCode				as addsAddTypeCode,
	A.[address]				as addsAddress1,
	A.[address_2]			as addsAddress2,
	NULL					as addsAddress3,
	A.[state]				as addsStateCode,
	A.[city]				as addsCity,
	NULL					as addnZipID,
	A.[zipcode]				as addsZip,
	A.[county]				as addsCounty,
	A.[country]				as addsCountry,
	null					as addbIsResidence,
	case when A.[default_addr]='Y' then 1
		else 0
	end						as addbPrimary,
	null,
	null,
	null,
	null,
	null,
	null,
	case
	  when isnull(A.company,'')<>'' then (
		'Company : ' + CHAR(13) + A.company
		)
	  else '' 		    
	end						as [addsComments],
	null,
	null,
	368						as addnRecUserID,
	getdate()				as adddDtCreated,
	368						as addnModifyUserID,
	getdate()				as adddDtModified,
	null,
	null,
	null,
	null,
	null
FROM [NeedlesKMY].[dbo].[multi_addresses] A
JOIN [sma_MST_Orgcontacts] O on O.saga = A.names_id
JOIN [sma_MST_AddressTypes] T on T.addnContactCategoryID = O.connContactCtg and T.addsCode='BR'
WHERE (A.[addr_type]='Other' and ( isnull(A.[address],'')<>'' or isnull(A.[address_2],'')<>'' or isnull( A.[city],'')<>'' or isnull(A.[state],'')<>'' or isnull(A.[zipcode],'')<>'' or isnull(A.[county],'')<>'' or isnull(A.[country],'')<>''))   
 
 
---(APPENDIX)---
---(A.0)
INSERT INTO [sma_MST_Address] (
		addnContactCtgID,
		addnContactID,
		addnAddressTypeID, 
		addsAddressType,
		addsAddTypeCode,
		addbPrimary,
		addnRecUserID,
		adddDtCreated
)
SELECT 
		I.cinnContactCtg  as addnContactCtgID,
		I.cinnContactID   as addnContactID,
		(select addnAddTypeID from [sma_MST_AddressTypes] where addsDscrptn='Other' and addnContactCategoryID=I.cinnContactCtg) as addnAddressTypeID, 
		'Other'		   as addsAddressType,
		'OTH'		   as addsAddTypeCode,
		1			   as addbPrimary,
		368			   as addnRecUserID,
		getdate()		   as adddDtCreated
FROM [sma_MST_IndvContacts] I
LEFT JOIN [sma_MST_Address] A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg
WHERE A.addnAddressID is NULL

---(A.1)
INSERT INTO [sma_MST_AddressTypes] (addsCode,addsDscrptn,addnContactCategoryID,addbIsWork)
SELECT 'OTH_O','Other',2,0
EXCEPT 
SELECT addsCode,addsDscrptn,addnContactCategoryID,addbIsWork FROM [sma_MST_AddressTypes] 


INSERT INTO [sma_MST_Address] (
		addnContactCtgID,
		addnContactID,
		addnAddressTypeID, 
		addsAddressType,
		addsAddTypeCode,
		addbPrimary,
		addnRecUserID,
		adddDtCreated
)
SELECT 
		O.connContactCtg  as addnContactCtgID,
		O.connContactID   as addnContactID,
		(select addnAddTypeID from [sma_MST_AddressTypes] where addsDscrptn='Other' and addnContactCategoryID=O.connContactCtg) as addnAddressTypeID, 
		'Other'		   as addsAddressType,
		'OTH_O'		   as addsAddTypeCode,
		1			   as addbPrimary,
		368			   as addnRecUserID,
		getdate()		   as adddDtCreated
FROM [sma_MST_OrgContacts] O
LEFT JOIN [sma_MST_Address] A on A.addnContactID=O.connContactID and A.addnContactCtgID=O.connContactCtg
WHERE A.addnAddressID is NULL

----(APPENDIX)----
UPDATE [sma_MST_Address] SET addbPrimary=1
FROM ( 
	SELECT 
		I.cinnContactID	as CID,
		A.addnAddressID as AID,
		ROW_NUMBER() OVER(PARTITION BY I.cinnContactID ORDER BY A.addnAddressID ASC) as RowNumber
	FROM [sma_MST_Indvcontacts] I 
	JOIN [sma_MST_Address] A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg and A.addbPrimary<>1 
	WHERE I.cinnContactID not in ( 
			SELECT I.cinnContactID
			FROM [sma_MST_Indvcontacts] I 
			JOIN [sma_MST_Address] A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg and A.addbPrimary=1 
			)
) A 
WHERE A.RowNumber=1
and A.AID=addnAddressID

UPDATE [sma_MST_Address] 
SET addbPrimary=1
FROM
( 
	 SELECT 
		O.connContactID	as CID,
		A.addnAddressID as AID,
		ROW_NUMBER() OVER(PARTITION BY O.connContactID ORDER BY A.addnAddressID ASC) as RowNumber
	 FROM [sma_MST_OrgContacts] O 
	 JOIN [sma_MST_Address] A on A.addnContactID=O.connContactID and A.addnContactCtgID=O.connContactCtg and A.addbPrimary<>1 
	 WHERE O.connContactID NOT IN ( 
			 SELECT O.connContactID
			 FROM [sma_MST_OrgContacts] O 
			 JOIN [sma_MST_Address] A on A.addnContactID=O.connContactID and A.addnContactCtgID=O.connContactCtg and A.addbPrimary=1 
			)
) A 
WHERE A.RowNumber=1
and A.AID=addnAddressID

 
---
ALTER TABLE [sma_MST_Address] ENABLE TRIGGER ALL
GO
---



------------- Check Uniqueness------------
-- select I.cinnContactID
-- 	 from [SA].[dbo].[sma_MST_Indvcontacts] I 
--	 inner join [SA].[dbo].[sma_MST_Address] A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg and A.addbPrimary=1 
--	 group by cinnContactID
--	 having count(cinnContactID)>1

-- select O.connContactID
-- 	 from [SA].[dbo].[sma_MST_OrgContacts] O 
--	 inner join [SA].[dbo].[sma_MST_Address] A on A.addnContactID=O.connContactID and A.addnContactCtgID=O.connContactCtg and A.addbPrimary=1 
--	 group by connContactID
--	 having count(connContactID)>1

