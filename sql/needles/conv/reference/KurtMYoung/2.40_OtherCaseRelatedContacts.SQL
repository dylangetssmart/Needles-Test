
USE SANeedlesKMY
GO

DECLARE @FileId int;
DECLARE @addnContactID int;
DECLARE @addnAddressID int;
DECLARE @addnContactCtgID int;
DECLARE @UTCCreationDateTime DateTime;
DECLARE @label varchar(100);
 
DECLARE OtherContact_cursor CURSOR FOR 
SELECT DISTINCT 
    CAS.casnCaseID,
    IOC.CID,
    IOC.AID,
    '',
    IOC.CTG,
    case
	   when P.[role] = 'See Relationship' then P.[relationship]
	   when P.[role] = 'Witness' then 'Witness ' + isnull(': ' + nullif(P.relationship,''),'')
	   else null
    end
FROM NeedlesKMY.[dbo].[party_Indexed] P 
JOIN [sma_TRN_Cases] CAS on CAS.cassCaseNumber=P.case_id
JOIN IndvOrgContacts_Indexed IOC on IOC.SAGA = P.party_id
WHERE P.role in
(
'See Relationship',
'Witness'
)



OPEN OtherContact_cursor 

FETCH NEXT FROM OtherContact_cursor 
INTO @FileId,@addnContactID,@addnAddressID,@UTCCreationDateTime,@addnContactCtgID,@label

WHILE @@FETCH_STATUS = 0
BEGIN

DECLARE @p1 VARCHAR(80);

EXEC [dbo].[sma_SP_Insert_OtherCaseRelatedContacts]
@CaseID=@FileId,   
@ContactID=@addnContactID,
@ContactCtgID=@addnContactCtgID,
@ContactAddressID=@addnAddressID,
@ContactRoleID=@label,
@ContactCreatedUserID=368,
@ContactComment=null,
@identity_column_value=@p1

PRINT @p1

FETCH NEXT FROM OtherContact_cursor 
INTO @FileId,@addnContactID,@addnAddressID,@UTCCreationDateTime,@addnContactCtgID,@label

END 

CLOSE OtherContact_cursor;
DEALLOCATE OtherContact_cursor;

GO

