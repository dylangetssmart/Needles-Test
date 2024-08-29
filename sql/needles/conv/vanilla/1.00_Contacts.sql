USE SATest
GO

--(0) saga field for needles names_id ---
ALTER TABLE [sma_MST_IndvContacts]
 ALTER COLUMN saga int
ALTER TABLE [sma_MST_OrgContacts]
 ALTER COLUMN saga int


---------------------------
--INSERT RACE
---------------------------
INSERT INTO sma_mst_contactRace (RaceDesc)
SELECT distinct Race_Name from TestNeedles..Race 
EXCEPT SELECT RaceDesc From sma_Mst_ContactRace


/* ###################################################################################
INSERT PLACEHOLDER INDV CONTACTS

1. Unassigned Staff
2. Unidentified Individual
3. Unidentified Plaintiff
4. Unidentified Defendant
*/ 

INSERT INTO [sma_MST_IndvContacts]
(
	[cinbPrimary]
	,[cinnContactTypeID]
	,[cinnContactSubCtgID]
	,[cinsPrefix]
	,[cinsFirstName]
	,[cinsMiddleName]
	,[cinsLastName]
	,[cinsSuffix]
	,[cinsNickName]
	,[cinbStatus]
	,[cinsSSNNo]
	,[cindBirthDate]
	,[cinsComments]
	,[cinnContactCtg]
	,[cinnRefByCtgID]
	,[cinnReferredBy]
	,[cindDateOfDeath]
	,[cinsCVLink]
	,[cinnMaritalStatusID]
	,[cinnGender]
	,[cinsBirthPlace]
	,[cinnCountyID]
	,[cinsCountyOfResidence]
	,[cinbFlagForPhoto]
	,[cinsPrimaryContactNo]
	,[cinsHomePhone]
	,[cinsWorkPhone]
	,[cinsMobile]
	,[cinbPreventMailing]
	,[cinnRecUserID]
	,[cindDtCreated]
	,[cinnModifyUserID]
	,[cindDtModified]
	,[cinnLevelNo]
	,[cinsPrimaryLanguage]
	,[cinsOtherLanguage]
	,[cinbDeathFlag]
	,[cinsCitizenship]
	,[cinsHeight]
	,[cinnWeight]
	,[cinsReligion]
	,[cindMarriageDate]
	,[cinsMarriageLoc]
	,[cinsDeathPlace]
	,[cinsMaidenName]
	,[cinsOccupation]
	,[saga]
	,[cinsSpouse]
	,[cinsGrade]
) 
-- 1: Unassigned Staff
SELECT DISTINCT 
    1                      as [cinbPrimary]
    ,10                     as [cinnContactTypeID]
    ,null                   as [cinnContactSubCtgID]
    ,null                   as [cinsPrefix]
    ,'Staff'            	as [cinsFirstName]
    ,''                     as [cinsMiddleName]
    ,'Unassigned'         	as [cinsLastName]
    ,null                   as [cinsSuffix]
    ,null                   as [cinsNickName]
    ,1                      as [cinbStatus]
    ,null                   as [cinsSSNNo]
    ,null                   as [cindBirthDate]
    ,null                   as [cinsComments]
    ,1                      as [cinnContactCtg]
    ,''                     as [cinnRefByCtgID]
    ,''                     as [cinnReferredBy]
    ,null                   as [cindDateOfDeath]
    ,''                     as [cinsCVLink]
    ,''                     as [cinnMaritalStatusID]
    ,1                      as [cinnGender]
    ,''                     as [cinsBirthPlace]
    ,1                      as [cinnCountyID]
    ,1                      as [cinsCountyOfResidence]
    ,null                   as [cinbFlagForPhoto]
    ,null                   as [cinsPrimaryContactNo]
    ,''                     as [cinsHomePhone]
    ,''                     as [cinsWorkPhone]
    ,null                   as [cinsMobile]
    ,0                      as [cinbPreventMailing]
    ,368                    as [cinnRecUserID]
    ,GETDATE()              as [cindDtCreated]
    ,''                     as [cinnModifyUserID]
    ,null                   as [cindDtModified]
    ,0                      as [cinnLevelNo]
    ,''                     as [cinsPrimaryLanguage]
    ,''                     as [cinsOtherLanguage]
    ,''                     as [cinbDeathFlag]
    ,''                     as [cinsCitizenship]
    ,null                   as [cinsHeight]
    ,''                     as [cinnWeight]
    ,''                     as [cinsReligion]
    ,null                   as [cindMarriageDate]
    ,null                   as [cinsMarriageLoc]
    ,null                   as [cinsDeathPlace]
    ,''                     as [cinsMaidenName]
    ,''                     as [cinsOccupation]
    ,-1                     as [saga]
    ,''                     as [cinsSpouse]
    ,null                   as [cinsGrade]
UNION
-- 2: Unidentified Individual
SELECT DISTINCT 
	1                      as [cinbPrimary]
    ,10                     as [cinnContactTypeID]
    ,null                   as [cinnContactSubCtgID]
    ,null                   as [cinsPrefix]
    ,'Individual'           as [cinsFirstName]
    ,''                     as [cinsMiddleName]
    ,'Unidentified'         as [cinsLastName]
    ,null                   as [cinsSuffix]
    ,null                   as [cinsNickName]
    ,1                      as [cinbStatus]
    ,null                   as [cinsSSNNo]
    ,null                   as [cindBirthDate]
    ,null                   as [cinsComments]
    ,1                      as [cinnContactCtg]
    ,''                     as [cinnRefByCtgID]
    ,''                     as [cinnReferredBy]
    ,null                   as [cindDateOfDeath]
    ,''                     as [cinsCVLink]
    ,''                     as [cinnMaritalStatusID]
    ,1                      as [cinnGender]
    ,''                     as [cinsBirthPlace]
    ,1                      as [cinnCountyID]
    ,1                      as [cinsCountyOfResidence]
    ,null                   as [cinbFlagForPhoto]
    ,null                   as [cinsPrimaryContactNo]
    ,''                     as [cinsHomePhone]
    ,''                     as [cinsWorkPhone]
    ,null                   as [cinsMobile]
    ,0                      as [cinbPreventMailing]
    ,368                    as [cinnRecUserID]
    ,GETDATE()              as [cindDtCreated]
    ,''                     as [cinnModifyUserID]
    ,null                   as [cindDtModified]
    ,0                      as [cinnLevelNo]
    ,''                     as [cinsPrimaryLanguage]
    ,''                     as [cinsOtherLanguage]
    ,''                     as [cinbDeathFlag]
    ,''                     as [cinsCitizenship]
    ,null                   as [cinsHeight]
    ,''                     as [cinnWeight]
    ,''                     as [cinsReligion]
    ,null                   as [cindMarriageDate]
    ,null                   as [cinsMarriageLoc]
    ,null                   as [cinsDeathPlace]
    ,''                     as [cinsMaidenName]
    ,''                     as [cinsOccupation]
    ,0	                    as [saga]
    ,''                     as [cinsSpouse]
    ,null                   as [cinsGrade]
UNION
-- 3: Unidentified Plaintiff
SELECT DISTINCT 
	1                      as [cinbPrimary]
    ,10                     as [cinnContactTypeID]
    ,null                   as [cinnContactSubCtgID]
    ,null                   as [cinsPrefix]
    ,'Plaintiff'            as [cinsFirstName]
    ,''                     as [cinsMiddleName]
    ,'Unidentified'         as [cinsLastName]
    ,null                   as [cinsSuffix]
    ,null                   as [cinsNickName]
    ,1                      as [cinbStatus]
    ,null                   as [cinsSSNNo]
    ,null                   as [cindBirthDate]
    ,null                   as [cinsComments]
    ,1                      as [cinnContactCtg]
    ,''                     as [cinnRefByCtgID]
    ,''                     as [cinnReferredBy]
    ,null                   as [cindDateOfDeath]
    ,''                     as [cinsCVLink]
    ,''                     as [cinnMaritalStatusID]
    ,1                      as [cinnGender]
    ,''                     as [cinsBirthPlace]
    ,1                      as [cinnCountyID]
    ,1                      as [cinsCountyOfResidence]
    ,null                   as [cinbFlagForPhoto]
    ,null                   as [cinsPrimaryContactNo]
    ,''                     as [cinsHomePhone]
    ,''                     as [cinsWorkPhone]
    ,null                   as [cinsMobile]
    ,0                      as [cinbPreventMailing]
    ,368                    as [cinnRecUserID]
    ,GETDATE()              as [cindDtCreated]
    ,''                     as [cinnModifyUserID]
    ,null                   as [cindDtModified]
    ,0                      as [cinnLevelNo]
    ,''                     as [cinsPrimaryLanguage]
    ,''                     as [cinsOtherLanguage]
    ,''                     as [cinbDeathFlag]
    ,''                     as [cinsCitizenship]
    ,null                   as [cinsHeight]
    ,''                     as [cinnWeight]
    ,''                     as [cinsReligion]
    ,null                   as [cindMarriageDate]
    ,null                   as [cinsMarriageLoc]
    ,null                   as [cinsDeathPlace]
    ,''                     as [cinsMaidenName]
    ,''                     as [cinsOccupation]
    ,''                     as [saga]
    ,''                     as [cinsSpouse]
    ,null                   as [cinsGrade]
UNION
-- 4: Unidentified Defendant
SELECT DISTINCT 
	1                      as [cinbPrimary]
    ,10                     as [cinnContactTypeID]
    ,null                   as [cinnContactSubCtgID]
    ,null                   as [cinsPrefix]
    ,'Defendant'            as [cinsFirstName]
    ,''                     as [cinsMiddleName]
    ,'Unidentified'         as [cinsLastName]
    ,null                   as [cinsSuffix]
    ,null                   as [cinsNickName]
    ,1                      as [cinbStatus]
    ,null                   as [cinsSSNNo]
    ,null                   as [cindBirthDate]
    ,null                   as [cinsComments]
    ,1                      as [cinnContactCtg]
    ,''                     as [cinnRefByCtgID]
    ,''                     as [cinnReferredBy]
    ,null                   as [cindDateOfDeath]
    ,''                     as [cinsCVLink]
    ,''                     as [cinnMaritalStatusID]
    ,1                      as [cinnGender]
    ,''                     as [cinsBirthPlace]
    ,1                      as [cinnCountyID]
    ,1                      as [cinsCountyOfResidence]
    ,null                   as [cinbFlagForPhoto]
    ,null                   as [cinsPrimaryContactNo]
    ,''                     as [cinsHomePhone]
    ,''                     as [cinsWorkPhone]
    ,null                   as [cinsMobile]
    ,0                      as [cinbPreventMailing]
    ,368                    as [cinnRecUserID]
    ,GETDATE()              as [cindDtCreated]
    ,''                     as [cinnModifyUserID]
    ,null                   as [cindDtModified]
    ,0                      as [cinnLevelNo]
    ,''                     as [cinsPrimaryLanguage]
    ,''                     as [cinsOtherLanguage]
    ,''                     as [cinbDeathFlag]
    ,''                     as [cinsCitizenship]
    ,null                   as [cinsHeight]
    ,''                     as [cinnWeight]
    ,''                     as [cinsReligion]
    ,null                   as [cindMarriageDate]
    ,null                   as [cinsMarriageLoc]
    ,null                   as [cinsDeathPlace]
    ,''                     as [cinsMaidenName]
    ,''                     as [cinsOccupation]
    ,''                     as [saga]
    ,''                     as [cinsSpouse]
    ,null                   as [cinsGrade]


---------------------------------------
-- Construct [sma_MST_IndvContacts]
---------------------------------------
INSERT INTO [sma_MST_IndvContacts]
(
	[cinsPrefix]
	,[cinsSuffix]
	,[cinsFirstName]
	,[cinsMiddleName]
	,[cinsLastName]
	,[cinsHomePhone]
	,[cinsWorkPhone]
	,[cinsSSNNo]
	,[cindBirthDate]
	,[cindDateOfDeath]
	,[cinnGender]
	,[cinsMobile]
	,[cinsComments]
	,[cinnContactCtg]
	,[cinnContactTypeID]
	,[cinnContactSubCtgID]
	,[cinnRecUserID]
	,[cindDtCreated]
	,[cinbStatus]	
	,[cinbPreventMailing]
	,[cinsNickName]
	,[cinsPrimaryLanguage]
    ,[cinsOtherLanguage]
	,[cinnRace]
	,[saga]					
)
SELECT										 
	left(N.[prefix],20)							as [cinsPrefix],
	left(N.[suffix],10)							as [cinsSuffix],
	convert(varchar(30),N.[first_name])			as [cinsFirstName],
	convert(varchar(30),N.[initial])			as [cinsMiddleName],
	convert(varchar(40),N.[last_long_name])		as [cinsLastName],
	left(N.[home_phone],20)						as [cinsHomePhone],
	left(N.[work_phone],20)						as [cinsWorkPhone],
	left(N.[ss_number],20)						as [cinsSSNNo],
	case
		when (N.[date_of_birth] not between '1900-01-01' and '2079-12-31') then getdate()
			else N.[date_of_birth]
		end										as [cindBirthDate],
	case
		when (N.[date_of_death] not between '1900-01-01' and '2079-12-31') then getdate()
			else N.[date_of_death]
		end										as [cindDateOfDeath],
	case
		when N.[sex]='M' then 1
		when N.[sex]='F' then 2
			else 0
		end										as [cinnGender],
	left(N.[car_phone],20)						as [cinsMobile],
	case
		when isnull(N.[fax_number],'') <> '' then 'FAX NUMBER: ' + N.[fax_number]
		else NULL
		end										as [cinsComments],
	1											as [cinnContactCtg],
	(
		select octnOrigContactTypeID
		from [sma_MST_OriginalContactTypes]
		where octsDscrptn='General' and octnContactCtgID=1
	)											as [cinnContactTypeID],
	case
		-- if names.deceased = "Y", then grab the contactSubCategoryID for "Deceased"
		when N.[deceased] = 'Y' then (
				select cscnContactSubCtgID
				from [sma_MST_ContactSubCategory]
				where cscsDscrptn='Deceased'
			)
		-- if incapacitated = "Y" on the [party_Indexed] table, then grab the contactSubCategoryID for "Incompetent"
		when exists (
			select *
			from [TestNeedles].[dbo].[party_Indexed] P
			where P.party_id=N.names_id and P.incapacitated='Y'
		) then (
			select cscnContactSubCtgID
			from [sma_MST_ContactSubCategory]
			where cscsDscrptn='Incompetent'
		)
		-- if minor = "Y" on the [party_Indexed] table, then grab the contactSubCategoryID for "Infant"
		-- otherwise, grab the contactSubCategoryID for "Adult"
		when exists (
			select *
			from [TestNeedles].[dbo].[party_Indexed] P
			where P.party_id=N.names_id and P.minor='Y'
		) then (
			select cscnContactSubCtgID
			from [sma_MST_ContactSubCategory]
			where cscsDscrptn='Infant'
			)
		else (
			select cscnContactSubCtgID
			from [sma_MST_ContactSubCategory]
			where cscsDscrptn='Adult'
		)
		end										as cinnContactSubCtgID,
	368											as cinnRecUserID,
	getdate()									as cindDtCreated,
	1											as [cinbStatus],			-- Hardcode Status as ACTIVE 
	0											as [cinbPreventMailing], 
	convert(varchar(15),aka_full)				as [cinsNickName],
	NULL										as [cinsPrimaryLanguage],
	null										as [cinsOtherLanguage],
	case
		when isnull(n.race,'') <> '' then
			(
				select raceid
				from sma_mst_ContactRace
				where RaceDesc = r.Race_Name
			) 
		else NULL
		end										as cinnrace,
	N.[names_id]								as saga  
FROM [TestNeedles].[dbo].[names] N
LEFT JOIN [TestNeedles].[dbo].[Race] r on r.race_ID = n.race
WHERE N.[person]='Y'


---------------------------------------
-- Construct [sma_MST_OrgContacts]
---------------------------------------
INSERT INTO [sma_MST_OrgContacts] (
		[consName],
		[consWorkPhone],
		[consComments],
		[connContactCtg],
		[connContactTypeID],	
		[connRecUserID],		
		[condDtCreated],
		[conbStatus],			
		[saga]					
	)
SELECT 
    N.[last_long_name]							as [consName],
    N.[work_phone]								as [consWorkPhone],
    case 
		when isnull(N.[aka_full],'') <> '' and  isnull(N.[email],'') = '' then (
			'AKA: ' +  N.[aka_full]
		)
		when isnull(N.[aka_full],'') = '' and  isnull(N.[email],'') <> '' then (
			'EMAIL: ' + N.[email]
		)
		when isnull(N.[aka_full],'') <> '' and  isnull(N.[email],'') <> '' then (
			'AKA: ' +  N.[aka_full] + ' EMAIL: ' + N.[email]
		)
    end											as [consComments],
    2											as [connContactCtg],
    (
		select octnOrigContactTypeID
		FROM .[sma_MST_OriginalContactTypes]
		where octsDscrptn='General' and octnContactCtgID=2
	)											as [connContactTypeID],
    368											as [connRecUserID],
    getdate()									as [condDtCreated],
    1											as [conbStatus],	-- Hardcode Status as ACTIVE
    N.[names_id]								as [saga]			-- remember the [names].[names_id] number
FROM [TestNeedles].[dbo].[names] N
WHERE N.[person] <> 'Y'

---------------------------------------
-- INDIVIDUAL CONTACT CARD FOR STAFF
---------------------------------------
INSERT INTO [sma_MST_IndvContacts] (
		[cinsPrefix],
		[cinsSuffix],
		[cinsFirstName],
		[cinsmiddleName],
		[cinsLastName],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsSSNNo],
		[cindBirthDate],
		[cindDateOfDeath],
		[cinnGender],
		[cinsMobile],
		[cinsComments],
		[cinnContactCtg],
		[cinnContactTypeID],	
		[cinnRecUserID],		
		[cindDtCreated],
		[cinbStatus],			
		[cinbPreventMailing],
		[cinsNickName],
		[saga],
		[cinsGrade]				-- remember the [staff_code]
)
SELECT 
		iu.Prefix							as [cinsPrefix],
		iu.Suffix							as [cinsSuffix],
		--left(isnull(first_name,dbo.get_firstword(full_name)),30)	as [cinsFirstName],
		SAFirst								as [cinsFirstName],
		SAMiddle							as [cinsmiddleName],
		--left(isnull(last_name,dbo.get_lastword(full_name)),40)	    as [cinsLastName],
		SALast								as [cinsLastName],
		NULL								as [cinsHomePhone],
		left(s.phone_number,20)				as [cinsWorkPhone],
		NULL								as [cinsSSNNo],
		NULL								as [cindBirthDate],
		NULL								as [cindDateOfDeath],
		case s.[sex] 
			when 'M' then 1
			when 'F' then 2
			else 0
		end									as [cinnGender],
		left(s.mobil_phone,20)   			as [cinsMobile],
		NULL								as [cinsComments],
		1									as [cinnContactCtg],
		(
			select octnOrigContactTypeID
			from sma_MST_OriginalContactTypes
			where octsDscrptn='General' and octnContactCtgID=1
		)									as [cinnContactTypeID],
		368, 
		getdate(),
		1									as [cinbStatus],
		0,
		convert(varchar(15),s.full_name)	as [cinsNickName],
		NULL								as [saga],
		staff_code							as [cinsGrade] -- Remember it to go to sma_MST_Users
--Select *
FROM [implementation_users] iu
LEFT JOIN [sma_MST_IndvContacts] ind on iu.StaffCode = ind.cinsgrade
LEFT JOIN TestNeedles..[staff] s on s.staff_code = iu.staffcode
WHERE cinncontactid IS NULL
and SALoginID <> 'aadmin'

---------------------------------------
-- EMAILS FOR STAFF
---------------------------------------
INSERT INTO [sma_MST_EmailWebsite]
  ( [cewnContactCtgID],[cewnContactID],[cewsEmailWebsiteFlag],[cewsEmailWebSite],[cewbDefault],[cewnRecUserID],[cewdDtCreated],[cewnModifyUserID],[cewdDtModified],[cewnLevelNo],[saga] )
SELECT 
		C.cinnContactCtg	as cewnContactCtgID,
		C.cinnContactID		as cewnContactID,
		'E'					as cewsEmailWebsiteFlag,
		s.email				as cewsEmailWebSite,
		null				as cewbDefault,
		368					as cewnRecUserID,
		getdate()			as cewdDtCreated,
		368					as cewnModifyUserID,
		getdate()			as cewdDtModified,
		null,
		1					as saga -- indicate email
FROM implementation_users iu
JOIN TestNeedles..staff s on s.staff_code = iu.staffcode
JOIN [sma_MST_IndvContacts] C on C.cinsgrade = iu.staffcode
WHERE isnull(email,'') <> ''

----------------------------------------------------
-- INSERT AADMIN USER IF DOES NOT ALREADY EXIST
----------------------------------------------------
IF (
	select count(*)
	from sma_mst_users
	where usrsloginid = 'aadmin'
	) = 0
BEGIN
	SET IDENTITY_INSERT sma_mst_users ON

	INSERT INTO [sma_MST_Users]
	(
		usrnuserid
		,[usrnContactID]
		,[usrsLoginID]
		,[usrsPassword]
		,[usrsBackColor]
		,[usrsReadBackColor]
		,[usrsEvenBackColor]
		,[usrsOddBackColor]
		,[usrnRoleID]
		,[usrdLoginDate]
		,[usrdLogOffDate]
		,[usrnUserLevel]
		,[usrsWorkstation]
		,[usrnPortno]
		,[usrbLoggedIn]
		,[usrbCaseLevelRights]
		,[usrbCaseLevelFilters]
		,[usrnUnsuccesfulLoginCount]
		,[usrnRecUserID]
		,[usrdDtCreated]
		,[usrnModifyUserID]
		,[usrdDtModified]
		,[usrnLevelNo]
		,[usrsCaseCloseColor]
		,[usrnDocAssembly]
		,[usrnAdmin]
		,[usrnIsLocked]
		,[usrbActiveState]
	)
	SELECT DISTINCT
		368							as usrnuserid
		,(
			SELECT
				TOP 1
				cinnContactID
			FROM
				dbo.sma_MST_IndvContacts
			WHERE
				cinslastname = 'Unassigned'
				AND cinsfirstname = 'Staff'
		)							as usrnContactID
		,'aadmin'					as usrsLoginID
		,'2/'				 as usrsPassword
		,null						as [usrsBackColor]
		,null						as [usrsReadBackColor]
		,null						as [usrsEvenBackColor]
		,null						as [usrsOddBackColor]
		,33							as [usrnRoleID]
		,null						as [usrdLoginDate]
		,null						as [usrdLogOffDate]
		,null						as [usrnUserLevel]
		,null						as [usrsWorkstation]
		,null						as [usrnPortno]
		,null						as [usrbLoggedIn]
		,null						as [usrbCaseLevelRights]
		,null						as [usrbCaseLevelFilters]
		,null						as [usrnUnsuccesfulLoginCount]
		,1							as [usrnRecUserID]
		,GETDATE()					as [usrdDtCreated]
		,null						as [usrnModifyUserID]
		,null						as [usrdDtModified]
		,null						as [usrnLevelNo]
		,null						as [usrsCaseCloseColor]
		,null						as [usrnDocAssembly]
		,null						as [usrnAdmin]
		,null						as [usrnIsLocked]
		,1							as [usrbActiveState]
	SET IDENTITY_INSERT sma_mst_users OFF
END

----------------------------------------------------
-- INSERT CONVERSION USER IF DOES NOT ALREADY EXIST
----------------------------------------------------
IF (
	select count(*)
	from sma_mst_users
	where usrsloginid = 'conversion'
	) = 0
BEGIN
	INSERT INTO [sma_MST_Users]
	(
		[usrnContactID]
		,[usrsLoginID]
		,[usrsPassword]
		,[usrsBackColor]
		,[usrsReadBackColor]
		,[usrsEvenBackColor]
		,[usrsOddBackColor]
		,[usrnRoleID]
		,[usrdLoginDate]
		,[usrdLogOffDate]
		,[usrnUserLevel]
		,[usrsWorkstation]
		,[usrnPortno]
		,[usrbLoggedIn]
		,[usrbCaseLevelRights]
		,[usrbCaseLevelFilters]
		,[usrnUnsuccesfulLoginCount]
		,[usrnRecUserID]
		,[usrdDtCreated]
		,[usrnModifyUserID]
		,[usrdDtModified]
		,[usrnLevelNo]
		,[usrsCaseCloseColor]
		,[usrnDocAssembly]
		,[usrnAdmin]
		,[usrnIsLocked]
		,[usrbActiveState]
	)
	SELECT DISTINCT
		(
			SELECT
				TOP 1
				cinnContactID
			FROM
				dbo.sma_MST_IndvContacts
			WHERE
				cinslastname = 'Unassigned'
				AND cinsfirstname = 'Staff'
		)							as usrnContactID
		,'conversion'				as usrsLoginID
		,'pass'				 		as usrsPassword
		,null						as [usrsBackColor]
		,null						as [usrsReadBackColor]
		,null						as [usrsEvenBackColor]
		,null						as [usrsOddBackColor]
		,33							as [usrnRoleID]
		,null						as [usrdLoginDate]
		,null						as [usrdLogOffDate]
		,null						as [usrnUserLevel]
		,null						as [usrsWorkstation]
		,null						as [usrnPortno]
		,null						as [usrbLoggedIn]
		,null						as [usrbCaseLevelRights]
		,null						as [usrbCaseLevelFilters]
		,null						as [usrnUnsuccesfulLoginCount]
		,1							as [usrnRecUserID]
		,GETDATE()					as [usrdDtCreated]
		,null						as [usrnModifyUserID]
		,null						as [usrdDtModified]
		,null						as [usrnLevelNo]
		,null						as [usrsCaseCloseColor]
		,null						as [usrnDocAssembly]
		,null						as [usrnAdmin]
		,null						as [usrnIsLocked]
		,1							as [usrbActiveState]
END

----------------------------------------------------
-- Add [saga] to [sma_MST_Users] if it does not exist
----------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_MST_Users'))
BEGIN
    ALTER TABLE [sma_MST_Users] ADD [saga] [varchar](20) NULL; 
END
GO

---------------------
-- INSERT USERS
---------------------

-- Insert data into sma_MST_Users table from implementation_users table
INSERT INTO [sma_MST_Users] (
    [usrnContactID],         -- Contact ID
    [usrsLoginID],           -- Login ID
    [usrsPassword],          -- Password
    [usrsBackColor],         -- Background Color
    [usrsReadBackColor],     -- Read Background Color
    [usrsEvenBackColor],     -- Even Background Color
    [usrsOddBackColor],      -- Odd Background Color
    [usrnRoleID],            -- Role ID
    [usrdLoginDate],         -- Login Date
    [usrdLogOffDate],        -- Log Off Date
    [usrnUserLevel],         -- User Level
    [usrsWorkstation],       -- Workstation
    [usrnPortno],            -- Port Number
    [usrbLoggedIn],          -- Logged In
    [usrbCaseLevelRights],   -- Case Level Rights
    [usrbCaseLevelFilters],  -- Case Level Filters
    [usrnUnsuccesfulLoginCount], -- Unsuccessful Login Count
    [usrnRecUserID],         -- Record User ID
    [usrdDtCreated],         -- Date Created
    [usrnModifyUserID],      -- Modify User ID
    [usrdDtModified],        -- Date Modified
    [usrnLevelNo],           -- Level Number
    [usrsCaseCloseColor],    -- Case Close Color
    [usrnDocAssembly],       -- Document Assembly
    [usrnAdmin],             -- Admin
    [usrnIsLocked],          -- Is Locked
    [saga],                  -- Staff Code
    [usrbActiveState],       -- Active State
    [usrbIsShowInSystem]     -- Show In System
)
SELECT 
    INDV.cinncontactid					 -- [usrnContactID]
    ,STF.SAloginID                      -- [usrsLoginID]
    ,'#'								 -- [usrsPassword]
    ,NULL                               -- [usrsBackColor]
    ,NULL                               -- [usrsReadBackColor]
    ,NULL                               -- [usrsEvenBackColor]
    ,NULL                               -- [usrsOddBackColor]
    ,33                                 -- [usrnRoleID]
    ,NULL                               -- [usrdLoginDate]
    ,NULL                               -- [usrdLogOffDate]
    ,NULL                               -- [usrnUserLevel]
    ,NULL                               -- [usrsWorkstation]
    ,NULL                               -- [usrnPortno]
    ,NULL                               -- [usrbLoggedIn]
    ,NULL                               -- [usrbCaseLevelRights]
    ,NULL                               -- [usrbCaseLevelFilters]
    ,NULL                               -- [usrnUnsuccesfulLoginCount]
    ,1                                  -- [usrnRecUserID]
    ,GETDATE()                          -- [usrdDtCreated]
    ,NULL                               -- [usrnModifyUserID]
    ,NULL                               -- [usrdDtModified]
    ,NULL                               -- [usrnLevelNo]
    ,NULL                               -- [usrsCaseCloseColor]
    ,NULL                               -- [usrnDocAssembly]
    ,NULL                               -- [usrnAdmin]
    ,NULL                               -- [usrnIsLocked]
    ,CONVERT(VARCHAR(20), STF.staffcode) -- [saga]
    ,0									as [usrbActiveState]
	,1									as [usrbIsShowInSystem]
FROM implementation_users STF
JOIN sma_MST_IndvContacts INDV
	ON INDV.cinsGrade = STF.staffcode
LEFT JOIN [sma_MST_Users] u
	ON u.saga = CONVERT(VARCHAR(20), STF.staffcode)
WHERE u.usrsLoginID IS NULL
GO

-----------------------------------------------END ADD USERS-----------------------------------------------

DECLARE @UserID int

DECLARE staff_cursor CURSOR FAST_FORWARD FOR SELECT usrnuserid from sma_mst_users

OPEN staff_cursor 

FETCH NEXT FROM staff_cursor INTO @UserID

SET NOCOUNT ON;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Print the fetched UserID for debugging
    PRINT 'Fetched UserID: ' + CAST(@UserID AS VARCHAR);

    -- Check if @UserID is NULL
    IF @UserID IS NOT NULL
    BEGIN
        PRINT 'Inserting for UserID: ' + CAST(@UserID AS VARCHAR);

        INSERT INTO sma_TRN_CaseBrowseSettings
        (
            cbsnColumnID
            ,cbsnUserID
            ,cbssCaption
            ,cbsbVisible
            ,cbsnWidth
            ,cbsnOrder
            ,cbsnRecUserID
            ,cbsdDtCreated
            ,cbsn_StyleName
        )
        SELECT DISTINCT
            cbcnColumnID
            ,@UserID
            ,cbcscolumnname
            ,'True'
            ,200
            ,cbcnDefaultOrder
            ,@UserID
            ,GETDATE()
            ,'Office2007Blue'
        FROM [sma_MST_CaseBrowseColumns]
        WHERE cbcnColumnID NOT IN (1, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 33);
    END
    ELSE
    BEGIN
        -- Log the NULL @UserID occurrence
        PRINT 'NULL UserID encountered. Skipping insert.';
    END
    
    FETCH NEXT FROM staff_cursor INTO @UserID;
END

CLOSE staff_cursor 
DEALLOCATE staff_cursor



---- Appendix ----
INSERT INTO Account_UsersInRoles ( user_id,role_id)
SELECT usrnUserID as user_id,2 as role_id 
FROM sma_MST_Users

update sma_MST_Users set usrbActiveState=1
where usrsLoginID='aadmin'

UPDATE Account_UsersInRoles 
SET role_id=1 
WHERE user_id=368 


