drop table [sma_MST_AllContactInfo]
GO

/****** Object:  Table [dbo].[sma_MST_AllContactInfo]    Script Date: 9/9/2015 12:29:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO


--sp_help sma_mst_address
CREATE TABLE [dbo].[sma_MST_AllContactInfo](
                [uId] [bigint] IDENTITY(1,1) NOT NULL,
                [UniqueContactId] [bigint] NOT NULL,
                [ContactId] [bigint] NOT NULL,
                [ContactCtg] [tinyint] NOT NULL,
                --[Name] [varchar](110) NULL,
                [Name] [varchar](210) NULL,
                [FirstName] [varchar](100) NULL,
                --[LastName] [varchar](90) NULL,
                [LastName] [varchar](200) NULL,
				[OtherName] [nvarchar](255) NULL,
                [AddressId] [bigint] NULL,
                --[Address1] [varchar](75) NULL,
				[Address1] [varchar](100) NULL,
                [Address2] [varchar](150) NULL,
                [Address3] [varchar](75) NULL,
                [City] [varchar](50) NULL,
                [State] [varchar](20) NULL,
                --[Zip] [varchar](10) NULL,
				[Zip] [varchar](20) NULL,
                [ContactNumber] [varchar](80) NULL,
                [ContactEmail] [varchar](255) NULL,
                [ContactTypeId] [int] NULL,
                [ContactType] [varchar](50) NULL,
                [Comments] [varchar](max) NULL,
                [DateModified] [datetime] NULL,
                [ModifyUserId] [int] NULL,
                [IsDeleted] [bit] NULL,
                [NameForLetters] [nvarchar](255) NULL,
                [DateOfBirth] [datetime] NULL,
                [SSNNo] [varchar](100) NULL,
                [County] [varchar](50) NULL,
                [IsActive] [bit] NULL,
CONSTRAINT [PK_sma_MST_AllContactInfo] PRIMARY KEY CLUSTERED 
(
                [uId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


delete from sma_MST_AllContactInfo
go
--insert org contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
		   ,[NameForLetters]
           ,[FirstName]
           ,[LastName]
	      ,[OtherName]
           ,[AddressId]
           ,[Address1]
           ,[Address2]
           ,[Address3]
           ,[City]
           ,[State]
           ,[Zip]
           ,[ContactNumber]
           ,[ContactEmail]
           ,[ContactTypeId]
           ,[ContactType]
           ,[Comments]
          ,[DateModified]
           ,[ModifyUserId]
           ,[IsDeleted]
                ,[IsActive])
     
                 SELECT convert(bigint, ('2' + convert(varchar(30),sma_MST_OrgContacts.connContactID))) as UniqueContactId,
                                                convert(bigint,sma_MST_OrgContacts.connContactID) as ContactId,
                                                2 as ContactCtg ,
                                                sma_MST_OrgContacts.consName as Name,
                                                sma_MST_OrgContacts.consName,
                                                null as FirstName,
                                                null as LastName, 
                                                sma_MST_OrgContacts.consOtherName as OtherName, 
                                                null as AddressId,
                                                null as Address1,
                                                null as Address2,
                                                null as Address3,
                                                null as City,
                                                null as State,
                                                null as Zip,
                                                null as ContactNumber,
                                                null as ContactEmail,
                                                sma_MST_OrgContacts.connContactTypeID as ContactTypeId,
                                                sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
                                                sma_MST_OrgContacts.consComments as Comments, 
                                                 GetDate() as DateModified,
                                                347 as ModifyUserId,
                                                0 as IsDeleted,
                                                [conbStatus]
                FROM sma_MST_OrgContacts
                left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_OrgContacts.connContactTypeID
GO
--insert individual contacts

INSERT INTO [dbo].[sma_MST_AllContactInfo]
           ([UniqueContactId]
           ,[ContactId]
           ,[ContactCtg]
           ,[Name]
           ,[NameForLetters]
           ,[FirstName]
           ,[LastName]
		   ,[OtherName]
           ,[AddressId]
           ,[Address1]
           ,[Address2]
           ,[Address3]
           ,[City]
           ,[State]
           ,[Zip]
           ,[ContactNumber]
           ,[ContactEmail]
           ,[ContactTypeId]
           ,[ContactType]
           ,[Comments]
           ,[DateModified]
           ,[ModifyUserId]
           ,[IsDeleted]
                ,[DateOfBirth],
[SSNNo]
,[IsActive] )
     
                 SELECT convert(bigint, ('1' + convert(varchar(30),sma_MST_IndvContacts.cinnContactID))) as UniqueContactId,
                                                convert(bigint,sma_MST_IndvContacts.cinnContactID) as ContactId,
                                                1 as ContactCtg ,
                                                  CASE ISNULL(cinsLastName,'') WHEN  '' THEN '' ELSE cinsLastName + ', ' END +
                                                                CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
                                                                + CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
                                                                + CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE  ', ' + cinsSuffix END   as Name,
                                                CASE ISNULL([cinsFirstName],'') WHEN '' THEN '' ELSE [cinsFirstName] END 
                                                +  CASE ISNULL(cinsMiddleName, '') WHEN '' THEN '' ELSE  ' ' + SUBSTRING(cinsMiddleName, 1, 1) + '.' END 
                                                + CASE ISNULL(cinsLastName,'') WHEN '' THEN '' ELSE ' ' + cinsLastName END 
                                                + CASE ISNULL(cinsSuffix, '') WHEN '' THEN '' ELSE ', ' + cinsSuffix END AS [NameForLetters],

                                                isnull(sma_MST_IndvContacts.cinsFirstName, '') as FirstName,
                                                isnull(sma_MST_IndvContacts.cinsLastName, '') as LastName,
                                                isnull(sma_MST_IndvContacts.cinsNickName, '') as OtherName,
                                                null as AddressId,
                                                null as Address1,
                                                null as Address2,
                                                null as Address3,
                                                null as City,
                                                null as State,
                                                null as Zip,
                                                null as ContactNumber,
                                                null as ContactEmail,
                                                sma_MST_IndvContacts.cinnContactTypeID as ContactTypeId,
                                                sma_MST_OriginalContactTypes.octsDscrptn as ContactType,
                                                sma_MST_IndvContacts.cinsComments as Comments, 
                                                 GetDate() as DateModified,
                                                347 as ModifyUserId,
                                                0 as IsDeleted,
                                                [cindBirthDate],
                                                [cinsSSNNo],
                                                [cinbStatus]
                FROM sma_MST_IndvContacts
                left join sma_MST_OriginalContactTypes on sma_MST_OriginalContactTypes.octnOrigContactTypeID = sma_MST_IndvContacts.cinnContactTypeID
				
GO
--fill out address information for all contact types
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [AddressId] = Addrr.addnAddressID
      ,[Address1] = Addrr.addsAddress1
      ,[Address2] = Addrr.addsAddress2
      ,[Address3] = Addrr.addsAddress3
      ,[City] = Addrr.addsCity
      ,[State] = Addrr.addsStateCode
      ,[Zip] = Addrr.addsZip
,[County] = Addrr.addsCounty
FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) 
GO

--fill out address information for all contact types, overwriting with primary addresses
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [AddressId] = Addrr.addnAddressID
      ,[Address1] = Addrr.addsAddress1
      ,[Address2] = Addrr.addsAddress2
      ,[Address3] = Addrr.addsAddress3
      ,[City] = Addrr.addsCity
      ,[State] = Addrr.addsStateCode
      ,[Zip] = Addrr.addsZip
,[County] = Addrr.addsCounty
FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_Address Addrr ON (AllInfo.ContactId = Addrr.addnContactID)  AND (AllInfo.ContactCtg = Addrr.addnContactCtgID) AND Addrr.addbPrimary = 1
GO
--fill out email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' 
GO

--fill out default email information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET [ContactEmail] = Email.cewsEmailWebSite
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_EmailWebsite Email ON (AllInfo.ContactId = Email.cewnContactID)  AND (AllInfo.ContactCtg = Email.cewnContactCtgID) AND Email.cewsEmailWebsiteFlag = 'E' AND Email.cewbDefault = 1
GO
--fill out phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber + (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID) 
GO

--fill out default phone information
UPDATE [dbo].[sma_MST_AllContactInfo]
   SET ContactNumber = Phones.cnnsContactNumber+ (CASE WHEN Phones.[cnnsExtension] IS NULL THEN '' WHEN Phones.[cnnsExtension] = '' THEN '' ELSE ' x' + Phones.[cnnsExtension] + '' END) 
  FROM
    sma_MST_AllContactInfo AllInfo
INNER JOIN sma_MST_ContactNumbers Phones ON (AllInfo.ContactId = Phones.cnnnContactID)  AND (AllInfo.ContactCtg = Phones.cnnnContactCtgID)  AND Phones.cnnbPrimary = 1
GO
GO
delete from [sma_MST_ContactTypesForContact]
INSERT INTO [sma_MST_ContactTypesForContact]
([ctcnContactCtgID],[ctcnContactID],[ctcnContactTypeID],[ctcnRecUserID],[ctcdDtCreated])
Select distinct  advnSrcContactCtg,advnSrcContactID,71,368,getdate() from sma_TRN_PdAdvt
Union
Select distinct 2,lwfnLawFirmContactID,9,368,GETDATE() from sma_TRN_LawFirms
Union
Select distinct 1,lwfnAttorneyContactID,7,368,GETDATE() from sma_TRN_LawFirms    
Union
Select distinct 2,incnInsContactID,11,368,GETDATE() from sma_TRN_InsuranceCoverage
Union
Select distinct 1,incnAdjContactId,8,368,GETDATE() from sma_TRN_InsuranceCoverage
Union
select distinct 1,pornPOContactID,86,368,GETDATE() from sma_TRN_PoliceReports
Union
Select distinct 1,usrncontactid,44,368,GETDATE() from sma_mst_users
go

GO

/****** Object:  Index [UniqueContactId]    Script Date: 9/21/2015 12:46:06 PM ******/
CREATE NONCLUSTERED INDEX [UniqueContactId] ON [dbo].[sma_MST_AllContactInfo]
(
                [UniqueContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [NonClusteredIndex-20141119-152835]    Script Date: 9/21/2015 12:45:52 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141119-152835] ON [dbo].[sma_MST_AllContactInfo]
(
                [UniqueContactId] ASC,
                [ContactId] ASC,
                [ContactCtg] ASC,
                [Name] ASC,
                [IsDeleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_Zip]    Script Date: 9/21/2015 12:45:38 PM ******/
CREATE NONCLUSTERED INDEX [index_Zip] ON [dbo].[sma_MST_AllContactInfo]
(
                [Zip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_State]    Script Date: 9/21/2015 12:45:17 PM ******/
CREATE NONCLUSTERED INDEX [index_State] ON [dbo].[sma_MST_AllContactInfo]
(
                [State] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_Name_UID]    Script Date: 9/21/2015 12:45:00 PM ******/
CREATE NONCLUSTERED INDEX [index_Name_UID] ON [dbo].[sma_MST_AllContactInfo]
(
                [Name] ASC,
                [UniqueContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_ContactTypeId]    Script Date: 9/21/2015 12:44:40 PM ******/
CREATE NONCLUSTERED INDEX [index_ContactTypeId] ON [dbo].[sma_MST_AllContactInfo]
(
                [ContactTypeId] ASC,
                [ContactId] ASC,
                [ContactCtg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_ContactCtg]    Script Date: 9/21/2015 12:44:20 PM ******/
CREATE NONCLUSTERED INDEX [index_ContactCtg] ON [dbo].[sma_MST_AllContactInfo]
(
                [ContactCtg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [index_City]    Script Date: 9/21/2015 12:44:03 PM ******/
CREATE NONCLUSTERED INDEX [index_City] ON [dbo].[sma_MST_AllContactInfo]
(
                [City] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [IDX_ContactID_CTG]    Script Date: 9/21/2015 12:43:35 PM ******/
CREATE NONCLUSTERED INDEX [IDX_ContactID_CTG] ON [dbo].[sma_MST_AllContactInfo]
(
                [ContactId] ASC,
                [ContactCtg] ASC
)
INCLUDE (           [NameForLetters]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [ContactTypeIndex]    Script Date: 9/21/2015 12:43:17 PM ******/
CREATE NONCLUSTERED INDEX [ContactTypeIndex] ON [dbo].[sma_MST_AllContactInfo]
(
                [ContactType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [CategoryId_ContactId]    Script Date: 9/21/2015 12:42:59 PM ******/
CREATE NONCLUSTERED INDEX [CategoryId_ContactId] ON [dbo].[sma_MST_AllContactInfo]
(
                [ContactCtg] ASC,
                [ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO



GO

/****** Object:  Index [AddressId]    Script Date: 9/21/2015 12:42:53 PM ******/
CREATE NONCLUSTERED INDEX [AddressId] ON [dbo].[sma_MST_AllContactInfo]
(
                [AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO

