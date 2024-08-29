-------------------------------------------------------------------------------------------------------------------------------
--WHEN YOU ADD MEDICAL RECORD TYPE, PLEASE ADD THE REFERENCE TO TABLE SMA_MST_REQUEST_RECORDTYPEDOCUMENTID AS SHOWN BELOW:
-------------------------------------------------------------------------------------------------------------------------------
INSERT INTO sma_MST_Request_RecordTypeDocumentID
SELECT DISTINCT [uid],0,0 
FROM sma_MST_Request_RecordTypes 
WHERE NOT EXISTS( select * from sma_MST_Request_RecordTypeDocumentID where uid=recordtypeid)
GO
---------------------------------------------------------------------------------------------
--FILL IN SMA_MST_CONTACTNUMBERS.DIGITCONTACTNUMBER IF TRIGGER WAS DISABLED DURING INSERT
---------------------------------------------------------------------------------------------
UPDATE sma_MST_ContactNumbers 
SET DigitContactNumber = dbo.RemoveAlphaCharactersN(cnnsContactNumber)
WHERE isnull(cnnscontactNumber,'') <> ''
GO
-----------------------------------
--CASE REFERRED OUT UPDATE
-----------------------------------
ALTER TABLE sma_trn_cases DISABLE TRIGGER ALL
GO
UPDATE c 
SET casbcaseout=1 
FROM sma_trn_referredout
JOIN sma_trn_cases c on casncaseid=rfoncaseid
GO
ALTER TABLE sma_trn_cases ENABLE TRIGGER ALL
GO 
----------------------------------------------------------------
--UPDATE KEY CONTACT CARDS AS LOCKED SO USERS CANNOT UPDATE
----------------------------------------------------------------
ALTER TABLE sma_MST_IndvContacts DISABLE TRIGGER ALL
GO
UPDATE sma_MST_IndvContacts
SET cinbLocked = 1
WHERE (cinsFirstName = 'John' and cinsLastName = 'Doe')
or (cinsFirstName = 'Plaintiff' and cinsLastName = 'Unidentified')
or (cinsFirstName = 'Defendant' and cinsLastName = 'Unidentified')
GO
ALTER TABLE sma_MST_IndvContacts ENABLE TRIGGER ALL
GO

---------------------------------------------
--CLEAN UP ALL CONTACT INFO CONTACT TYPES
---------------------------------------------
UPDATE AI
SET ContactTypeId = smctfc.octnOrigContactTypeID,
ContactType = smctfc.octsDscrptn
--select *
FROM sma_MST_AllContactInfo AI
INNER JOIN sma_MST_OrgContacts smoc ON smoc.connContactID = AI.ContactId AND AI.ContactCtg = 2
LEFT JOIN sma_MST_OriginalContactTypes smctfc ON smctfc.octnOrigContactTypeID = smoc.connContactTypeID
--WHERE smoc.connContactID = 148

UPDATE AI
SET ContactTypeId = smctfc.octnOrigContactTypeID,
ContactType = smctfc.octsDscrptn
--select *
FROM sma_MST_AllContactInfo AI
INNER JOIN sma_MST_IndvContacts smic ON smic.cinnContactID = AI.ContactId AND AI.ContactCtg = 1
LEFT JOIN sma_MST_OriginalContactTypes smctfc ON smctfc.octnOrigContactTypeID = smic.cinnContactTypeID