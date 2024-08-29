use SANeedlesKMY

/* ####################################
1.0 -- Add Contact to case
*/

alter table [sma_MST_OtherCasesContact] disable trigger all
GO

INSERT INTO [sma_MST_OtherCasesContact]
(
	[OtherCasesID]
    ,[OtherCasesContactID]
    ,[OtherCasesContactCtgID]
    ,[OtherCaseContactAddressID]
    ,[OtherCasesContactRole]
    ,[OtherCasesCreatedUserID]
    ,[OtherCasesContactCreatedDt]
    ,[OtherCasesModifyUserID]
    ,[OtherCasesContactModifieddt]
)
SELECT 
	cas.casnCaseID				as [OtherCasesID]
	,ioc.CID					as [OtherCasesContactID]
	,ioc.CTG					as [OtherCasesContactCtgID]
	,ioc.AID					as [OtherCaseContactAddressID]
	,'Contact Relationships'	as [OtherCasesContactRole]
	,368						as [OtherCasesCreatedUserID]
	,getdate()					as [OtherCasesContactCreatedDt]
	,null						as [OtherCasesModifyUserID]
	,null						as [OtherCasesContactModifieddt]
FROM NeedlesKMY.[dbo].user_party_data ud
join sma_TRN_Cases cas
	on cas.cassCaseNumber = ud.case_id
join NeedlesKMY..names n
	on n.names_id = ud.party_id
join IndvOrgContacts_Indexed ioc
	on ioc.SAGA = n.names_id
where isnull(ud.Spouse,'') <> '' or isnull(ud.Alternate_Contact,'') <> '' or isnull(ud.Contact_Relationship,'') <> ''
GO

---
alter table [sma_MST_OtherCasesContact] enable trigger all
GO

/* ####################################
2.0 -- Add comment
*/
                
INSERT INTO [sma_TRN_CaseContactComment]
(
	[CaseContactCaseID]
	,[CaseRelContactID]
	,[CaseRelContactCtgID]
	,[CaseContactComment]
	,[CaseContactCreaatedBy]
	,[CaseContactCreateddt]
	,[caseContactModifyBy]
	,[CaseContactModifiedDt]
)
SELECT
	cas.casnCaseID	as [CaseContactCaseID]
	,ioc.CID		as [CaseRelContactID]
	,ioc.CTG		as [CaseRelContactCtgID]
	,isnull(('Spouse: '+ nullif(convert(varchar(max),ud.spouse),'')+char(13)),'') +
	isnull(('Alternate Contact: '+ nullif(convert(varchar(max),ud.Alternate_Contact),'')+char(13)),'') +
	isnull(('Contact Relationship: '+ nullif(convert(varchar(max),ud.Contact_Relationship),'')+char(13)),'') +
	''				as [CaseContactComment]
	,368			as [CaseContactCreaatedBy]
	,getdate()		as [CaseContactCreateddt]
	,null			as [caseContactModifyBy]
	,null			as [CaseContactModifiedDt]
FROM NeedlesKMY.[dbo].user_party_data ud
join sma_TRN_Cases cas
	on cas.cassCaseNumber = ud.case_id
join NeedlesKMY..names n
	on n.names_id = ud.party_id
join IndvOrgContacts_Indexed ioc
	on ioc.SAGA = n.names_id
where isnull(ud.Spouse,'') <> '' or isnull(ud.Alternate_Contact,'') <> '' or isnull(ud.Contact_Relationship,'') <> ''