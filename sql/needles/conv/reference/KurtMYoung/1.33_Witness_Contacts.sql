USE SANeedlesKMY
GO

--
ALTER TABLE [sma_MST_IndvContacts] DISABLE TRIGGER ALL
GO
--
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
SELECT DISTINCT 
     1                      as [cinbPrimary]
    ,10                     as [cinnContactTypeID]
    ,null                   as [cinnContactSubCtgID]
    ,''                     as [cinsPrefix]
    ,dbo.get_firstword(utd.Witness_Name)     as [cinsFirstName]
    ,''                               as [cinsMiddleName]
    ,dbo.get_lastword(utd.Witness_Name)      as [cinsLastName]
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
    ,null + null            as [cinsHeight]
    ,null                   as [cinnWeight]
    ,''                     as [cinsReligion]
    ,null                   as [cindMarriageDate]
    ,null                   as [cinsMarriageLoc]
    ,null                   as [cinsDeathPlace]
    ,''                     as [cinsMaidenName]
    ,''                     as [cinsOccupation]
    ,''                     as [saga]
    ,''                     as [cinsSpouse]
    ,-1                     as [cinsGrade]
FROM [NeedlesKMY].[dbo].[user_tab_data] utd
	--JOIN sma_trn_Cases cas
		--on cas.cassCaseNumber = convert(varchar,ud.case_id)
	
	-- Link to SA Contact Card via:
	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
	join NeedlesKMY.dbo.user_tab_name utn
		on utd.tab_id = utn.tab_id
	join NeedlesKMY.dbo.names n
		on utn.user_name = n.names_id
	
	-- Indv
	--left join SANeedlesKMY.dbo.IndvOrgContacts_Indexed ioci
		--on n.names_id = ioci.saga
		--and ioci.CTG = 1

	-- Org
--	left join SANeedlesKMY.dbo.IndvOrgContacts_Indexed ioco
	--	on n.names_id = ioco.saga
		--and ioco.CTG = 2

WHERE isnull(utd.Witness_Name,'')<>''

GO

--
ALTER TABLE [sma_MST_IndvContacts] ENABLE TRIGGER ALL
GO
