
-- USE [SANeedlesSLF]
GO
---(1)--- Phone number uniqueness

UPDATE [dbo].[sma_MST_ContactNumbers] SET cnnbPrimary=0
WHERE cnnnContactCtgID=1

UPDATE [dbo].[sma_MST_ContactNumbers] SET cnnbPrimary=0
WHERE cnnnContactCtgID=2


---(Note: If cell phone exists, set the first cell phone primary or the only one. )
UPDATE [dbo].[sma_MST_ContactNumbers] 
SET cnnbPrimary= case when A.RowNumber = 1 then 1 else 0 end
FROM (
	SELECT 
		ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID ASC )  as RowNumber,
		cnnnContactNumberID	as ContactNumberID
	FROM [dbo].[sma_MST_ContactNumbers] CN
	JOIN [dbo].[sma_MST_ContactNoType] CT on CT.ctynContactNoTypeID=CN.cnnnPhoneTypeID
	WHERE ctysDscrptn='Work Phone' and ctynContactCategoryID=1 
) A WHERE A.ContactNumberID=cnnnContactNumberID


UPDATE [dbo].[sma_MST_ContactNumbers] set cnnbPrimary = case when A.RowNumber = 1 then 1 else 0 end
FROM (
	SELECT 
		ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID ASC )  as RowNumber,
		cnnnContactNumberID	   as ContactNumberID
	FROM [dbo].[sma_MST_ContactNumbers] 
	WHERE cnnnContactCtgID=1
	and cnnnContactID NOT IN ( 	  
					SELECT DISTINCT cnnnContactID FROM [dbo].[sma_MST_ContactNumbers] CN
					JOIN [dbo].[sma_MST_ContactNoType] CT on CT.ctynContactNoTypeID=CN.cnnnPhoneTypeID
					WHERE ctysDscrptn='Work Phone' and ctynContactCategoryID=1 )
	and cnnnContactCtgID=1
) A 
WHERE A.ContactNumberID=cnnnContactNumberID


---(Note: If cell phone exists, set the first cell phone primary or the only one.)
UPDATE [dbo].[sma_MST_ContactNumbers] 
SET cnnbPrimary= case when A.RowNumber = 1 then 1 else 0 end
FROM (
	SELECT 
		ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID ASC )  as RowNumber,
		cnnnContactNumberID as ContactNumberID
	FROM [dbo].[sma_MST_ContactNumbers] CN
	JOIN [dbo].[sma_MST_ContactNoType] CT on CT.ctynContactNoTypeID=CN.cnnnPhoneTypeID
	WHERE ctysDscrptn='Cell' and ctynContactCategoryID=2 
) A 
WHERE A.ContactNumberID=cnnnContactNumberID


UPDATE [dbo].[sma_MST_ContactNumbers] set cnnbPrimary = case when A.RowNumber = 1 then 1 else 0 end
FROM (
		SELECT 
			ROW_NUMBER() OVER (Partition BY cnnnContactID order by cnnnContactNumberID ASC )  as RowNumber,
			cnnnContactNumberID	   as ContactNumberID
		FROM [dbo].[sma_MST_ContactNumbers] 
		WHERE cnnnContactCtgID=2
		and cnnnContactID NOT IN ( 	  
						SELECT DISTINCT cnnnContactID FROM [dbo].[sma_MST_ContactNumbers] CN
						JOIN [dbo].[sma_MST_ContactNoType] CT on CT.ctynContactNoTypeID=CN.cnnnPhoneTypeID
						WHERE ctysDscrptn='Cell' and ctynContactCategoryID=2 )
		and cnnnContactCtgID=2
) A 
WHERE A.ContactNumberID=cnnnContactNumberID

---------------------------------
---CHECK RESULT
---------------------------------
SELECT count(*) 
FROM [dbo].[sma_MST_ContactNumbers] 
WHERE cnnnContactCtgID=2 and cnnbPrimary= 1

SELECT count(distinct cnnnContactID) 
FROM [dbo].[sma_MST_ContactNumbers] 
WHERE cnnnContactCtgID=2
GO

---------------------------------
---(2)--- EMAIL UNIQUENESS
---------------------------------
UPDATE [sma_MST_EmailWebsite] 
SET cewbDefault = case when A.RowNumber = 1 then 1
					else 0 end
FROM (
		SELECT 
			ROW_NUMBER() OVER (Partition BY cewnContactID order by cewnEmlWSID ASC )  as RowNumber,
			cewnEmlWSID as EmlWSID
		FROM [sma_MST_EmailWebsite] 
		WHERE cewnContactCtgID = (select ctgnCategoryID FROM sma_MST_ContactCtg where ctgsDesc='Individual')
) A
WHERE A.EmlWSID=cewnEmlWSID

---
UPDATE [sma_MST_EmailWebsite] 
SET cewbDefault = case when A.RowNumber = 1 then 1
					else 0 end 
FROM (
		SELECT 
			ROW_NUMBER() OVER (Partition BY cewnContactID order by cewnEmlWSID ASC )  as RowNumber,
			cewnEmlWSID as EmlWSID
		FROM [sma_MST_EmailWebsite] 
		WHERE cewnContactCtgID = (select ctgnCategoryID FROM sma_MST_ContactCtg where ctgsDesc='Organization')
) A
WHERE A.EmlWSID=cewnEmlWSID
GO

---------------------------------
---(3)--- ADDRESS UNIQUENESS
---------------------------------
UPDATE [sma_MST_Address] 
SET addbPrimary = case when A.RowNumber = 1 then 1
					else 0 end
FROM (
		SELECT 
			ROW_NUMBER() OVER (Partition BY addnContactID order by addnAddressID ASC )  as RowNumber,
			addnAddressID as AddressID
		FROM [sma_MST_Address] 
		WHERE addnContactCtgID = (select ctgnCategoryID FROM sma_MST_ContactCtg where ctgsDesc='Individual')
) A
WHERE A.AddressID=addnAddressID


UPDATE [sma_MST_Address] 
SET addbPrimary = case when A.RowNumber = 1 then 1
					else 0 end
FROM (
		SELECT 
			ROW_NUMBER() OVER (Partition BY addnContactID order by addnAddressID ASC )  as RowNumber,
			addnAddressID as AddressID
		FROM [sma_MST_Address] 
		WHERE addnContactCtgID = (select ctgnCategoryID FROM sma_MST_ContactCtg where ctgsDesc='Organization')
) A
WHERE A.AddressID=addnAddressID


---(Appendix)--- normalize phone format
ALTER TABLE sma_MST_ContactNumbers DISABLE TRIGGER ALL
GO
UPDATE sma_MST_ContactNumbers 
SET cnnsContactNumber=
    case
	   when len(dbo.RemoveAlphaCharactersN(cnnsContactNumber))=10 then '(' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),1,3) + ') ' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),4,3) + '-' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),7,4) 
	   when len(dbo.RemoveAlphaCharactersN(cnnsContactNumber))=11 and left(dbo.RemoveAlphaCharactersN(cnnsContactNumber),1)='1' then '(' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),2,3) + ') ' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),5,3) + '-' + SUBSTRING(dbo.RemoveAlphaCharactersN(cnnsContactNumber),8,4)
	   else dbo.RemoveAlphaCharactersN(cnnsContactNumber)
    end 
GO

ALTER TABLE sma_MST_ContactNumbers ENABLE TRIGGER ALL
GO
