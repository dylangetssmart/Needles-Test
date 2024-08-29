USE [SANeedlesKMY]
GO
/*
alter table [sma_MST_EmailWebsite] disable trigger all
delete from [sma_MST_EmailWebsite] 
DBCC CHECKIDENT ('[sma_MST_EmailWebsite]', RESEED, 0);
alter table [sma_MST_EmailWebsite] enable trigger all
*/

---
ALTER TABLE [sma_MST_EmailWebsite] DISABLE TRIGGER ALL
GO
---------------------------------------------------------------------
----- (1/3) CONSTRUCT SMA_MST_EMAILWEBSITE FOR INDIVIDUAL -
---------------------------------------------------------------------

INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.cinnContactCtg	as cewnContactCtgID,
		C.cinnContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.email				as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		1					as saga -- indicate email
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
WHERE isnull(email,'') <> ''


INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.cinnContactCtg	as cewnContactCtgID,
		C.cinnContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.email_work		as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		2					as saga -- indicate email_work
 FROM [NeedlesKMY].[dbo].[names] N
 JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
 WHERE isnull(email_work,'') <> ''


 INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
 SELECT 
		C.cinnContactCtg	as cewnContactCtgID,
		C.cinnContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.other_email		as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		3					as saga -- indicate other_email
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
WHERE isnull(other_email,'') <> ''


INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.cinnContactCtg	as cewnContactCtgID,
		C.cinnContactID		as cewnContactID,
		'W'					as cewsEmailWebsiteFlag,
		N.website			as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		4					as saga -- indicate website
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_IndvContacts] C on C.saga = N.names_id
WHERE isnull(website,'') <> ''

--------------------------------------------------------------------
----- (2/3) CONSTRUCT SMA_MST_EMAILWEBSITE FOR ORGANIZATION ------
--------------------------------------------------------------------
INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.connContactCtg	as cewnContactCtgID,
		C.connContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.email				as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		1					as saga -- indicate email
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
WHERE isnull(email,'') <> ''

INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.connContactCtg	as cewnContactCtgID,
		C.connContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.email_work		as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		2					as saga -- indicate email_work
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
WHERE isnull(email_work,'') <> ''


INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.connContactCtg	as cewnContactCtgID,
		C.connContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		N.other_email		as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		3					as saga -- indicate other_email
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
WHERE isnull(other_email,'') <> ''

INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.connContactCtg	as cewnContactCtgID,
		C.connContactID		as cewnContactID,
		'W'					as cewsEmailWebsiteFlag,
		N.website			as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		4					as saga -- indicate website
FROM [NeedlesKMY].[dbo].[names] N
JOIN [sma_MST_OrgContacts] C on C.saga = N.names_id
WHERE isnull(website,'') <> ''

 ---
 ALTER TABLE [sma_MST_EmailWebsite] ENABLE TRIGGER ALL
 GO
 ---


 /*
---- (3/3 set default)

update [sma_MST_EmailWebsite] set cewbDefault=0  
update [sma_MST_EmailWebsite] set cewbDefault=1 where cewsEmailWebsiteFlag='W'

declare @cewnContactID int;
declare @email_Count int;
declare @email_work_Count int;
declare @other_email_Count int;

declare @email_cewnEmlWSID int;
declare @email_work_cewnEmlWSID int;
declare @other_email_cewnEmlWSID int;
 
DECLARE EmailWebsite_cursor CURSOR FOR 
select distinct cewnContactID from [sma_MST_EmailWebsite]

OPEN EmailWebsite_cursor 

FETCH NEXT FROM EmailWebsite_cursor
INTO @cewnContactID

WHILE @@FETCH_STATUS = 0
BEGIN

select @email_Count=count(*),@email_cewnEmlWSID=min(cewnEmlWSID) from [sma_MST_EmailWebsite] where cewnContactID=@cewnContactID and saga=1 
select @email_work_Count=count(*),@email_work_cewnEmlWSID=min(cewnEmlWSID) from [sma_MST_EmailWebsite] where cewnContactID=@cewnContactID and saga=2
select @other_email_Count=count(*),@other_email_cewnEmlWSID=min(cewnEmlWSID) from [sma_MST_EmailWebsite] where cewnContactID=@cewnContactID and saga=3

if ( @email_Count != 0 )
begin
update [sma_MST_EmailWebsite] set cewbDefault=1 where cewnEmlWSID=@email_cewnEmlWSID
end

if ( @email_Count = 0 and @email_work_Count != 0)
begin
update [sma_MST_EmailWebsite] set cewbDefault=1 where cewnEmlWSID=@email_work_cewnEmlWSID
end

if ( @email_Count = 0 and @email_work_Count = 0 and @other_email_Count <> 0)
begin
update [sma_MST_EmailWebsite] set cewbDefault=1 where cewnEmlWSID=@other_email_cewnEmlWSID
end


FETCH NEXT FROM EmailWebsite_cursor
INTO @cewnContactID

END 

CLOSE EmailWebsite_cursor;
DEALLOCATE EmailWebsite_cursor;

*/


