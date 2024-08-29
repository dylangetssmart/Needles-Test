-- USE [SANeedlesSLF]
GO


---(0)---
IF EXISTS (select * from sys.objects where name='TempCaseName' and type='U') 
BEGIN
    DROP TABLE TempCaseName
END

SELECT 
    CAS.casnCaseID	    as CaseID,
    CAS.cassCaseName    as CaseName,
    isnull(IOC.Name,'') + ' v. ' + isnull(IOCD.Name,'') as NewCaseName 
INTO TempCaseName
FROM sma_TRN_Cases CAS
LEFT JOIN sma_TRN_Plaintiff T on T.plnnCaseID=CAS.casnCaseID and T.plnbIsPrimary=1
LEFT JOIN
    (
	SELECT cinnContactID as CID, cinnContactCtg as CTG, cinsFirstName + ' ' + cinsLastName as Name, saga as SAGA FROM [sma_MST_IndvContacts]  
	UNION
	SELECT connContactID as CID, connContactCtg as CTG, consName as Name, saga as SAGA FROM [sma_MST_OrgContacts]  
    ) IOC on IOC.CID=T.plnnContactID and IOC.CTG=T.plnnContactCtg
LEFT JOIN sma_TRN_Defendants D on D.defnCaseID=CAS.casnCaseID and D.defbIsPrimary=1
LEFT JOIN
    (
	SELECT cinnContactID as CID, cinnContactCtg as CTG, cinsFirstName + ' ' + cinsLastName as Name, saga as SAGA FROM [sma_MST_IndvContacts]
	UNION
	SELECT connContactID as CID, connContactCtg as CTG, consName as Name, saga as SAGA FROM [sma_MST_OrgContacts]  
    ) IOCD on IOCD.CID=D.defnContactID and IOCD.CTG=D.defnContactCtgID


---(1)---
ALTER TABLE [sma_TRN_Cases] DISABLE TRIGGER ALL
GO
UPDATE sma_TRN_Cases SET cassCaseName=A.NewCaseName
FROM TempCaseName A
WHERE A.CaseID=casnCaseID and isnull(A.CaseName,'')=''

ALTER TABLE [sma_TRN_Cases] ENABLE TRIGGER ALL
GO
