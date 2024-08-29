/* ########################################################
Create contact cards for Plaintiff Spouses from user_party_data
- See 2.05_Plaintiff_Defendant
*/

ALTER TABLE [sma_MST_IndvContacts] DISABLE TRIGGER ALL
GO
--

if not exists (SELECT * FROM sys.columns WHERE Name = N'saga_ref' AND Object_ID = Object_ID(N'sma_MST_IndvContacts'))
begin
    ALTER TABLE [sma_MST_IndvContacts] ADD [saga_ref] [varchar](100) NULL; 
end
GO

INSERT INTO [sma_MST_IndvContacts] (
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
	,[saga_ref]
) 
SELECT DISTINCT 
     1									as [cinbPrimary]
    ,(
		SELECT octnOrigContactTypeID
		FROM [dbo].[sma_MST_OriginalContactTypes]
		WHERE octsDscrptn = 'General' and octnContactCtgID = 1
	)									as [cinnContactTypeID]
    ,null								as [cinnContactSubCtgID]
    ,null		                        as [cinsPrefix]
    ,dbo.get_firstword(p.Spouse)  	    as [cinsFirstName]
    ,''                             	as [cinsMiddleName]
    ,dbo.get_lastword(p.Spouse)     	as [cinsLastName]
    ,null                               as [cinsSuffix]
    ,null                               as [cinsNickName]
    ,1                                  as [cinbStatus]
    ,p.Spouses_SS_Number                as [cinsSSNNo]
    ,case
        when (p.Spouses_DOB between '1900-01-01' and '2079-06-06')
            then p.Spouses_DOB
    else null
    end								    as [cindBirthDate]
    ,null                               as [cinsComments]
    ,1                                  as [cinnContactCtg]
    ,''                                 as [cinnRefByCtgID]
    ,''                                 as [cinnReferredBy]
    ,null                               as [cindDateOfDeath]
    ,''                                 as [cinsCVLink]
    ,''                                 as [cinnMaritalStatusID]
    ,1                                  as [cinnGender]
    ,''                                 as [cinsBirthPlace]
    ,1                                  as [cinnCountyID]
    ,1                                  as [cinsCountyOfResidence]
    ,null                               as [cinbFlagForPhoto]
    ,null                               as [cinsPrimaryContactNo]
    ,''                                 as [cinsHomePhone]
    ,''                                 as [cinsWorkPhone]
    ,null                               as [cinsMobile]
    ,0                                  as [cinbPreventMailing]
    ,368                                as [cinnRecUserID]
    ,GETDATE()                          as [cindDtCreated]
    ,''                                 as [cinnModifyUserID]
    ,null                               as [cindDtModified]
    ,0                                  as [cinnLevelNo]
    ,''                                 as [cinsPrimaryLanguage]
    ,''                                 as [cinsOtherLanguage]
    ,''                                 as [cinbDeathFlag]
    ,''                                 as [cinsCitizenship]
    ,null + null                        as [cinsHeight]
    ,null                               as [cinnWeight]
    ,''                                 as [cinsReligion]
    ,null                               as [cindMarriageDate]
    ,null                               as [cinsMarriageLoc]
    ,null                               as [cinsDeathPlace]
    ,''                                 as [cinsMaidenName]
    ,''                                 as [cinsOccupation]
    ,p.case_id                          as [saga]
    ,''                                 as [cinsSpouse]
    ,null                        	    as [cinsGrade]
	,'plaintiff-spouse'					as [saga_ref]
FROM [NeedlesSLF].[dbo].[user_party_data] p
WHERE ISNULL(p.Spouse, '') <> '' --or isnull(p.Spouses_DOB,'') <> '' or isnull(p.Spouses_SS_Number,'') <> ''
GO

---
ALTER TABLE [sma_MST_IndvContacts] ENABLE TRIGGER ALL
GO
---