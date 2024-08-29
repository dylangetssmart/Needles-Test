
use SANeedlesKMY
GO

------
ALTER TABLE sma_MST_OrgContacts DISABLE TRIGGER ALL
GO
ALTER TABLE sma_MST_IndvContacts DISABLE TRIGGER ALL
GO
-----

----(0)----

UPDATE [sma_MST_IndvContacts] SET cinnContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Adjuster' and octnContactCtgID=1)
WHERE cinnContactID in
(
SELECT DISTINCT incnAdjContactId 
FROM [sma_TRN_InsuranceCoverage] INS
WHERE incnAdjContactId is not null
) 

GO

UPDATE [sma_MST_OrgContacts] SET connContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Insurance Company' and octnContactCtgID=2)
WHERE connContactID in
(
SELECT DISTINCT incnInsContactID
FROM [sma_TRN_InsuranceCoverage] INS
WHERE incnInsContactID is not null
)
GO


----(1)----

UPDATE [sma_MST_IndvContacts] SET cinnContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Doctor' and octnContactCtgID=1)
WHERE cinnContactID in
(
SELECT DISTINCT hosnContactID 
from [sma_TRN_Hospitals] HOS
WHERE hosnContactID is not null
and hosnContactCtg=1
) 
GO

UPDATE [sma_MST_OrgContacts] SET connContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Medical Office' and octnContactCtgID=2)
WHERE connContactID in
(
SELECT DISTINCT hosnContactID 
FROM [sma_TRN_Hospitals] HOS
WHERE hosnContactID is not null
and hosnContactCtg=2
)
GO



----(2)----

UPDATE [sma_MST_IndvContacts] SET cinnContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Attorney' and octnContactCtgID=1)
WHERE cinnContactID in
(
SELECT DISTINCT planAtorneyContactID FROM [sma_TRN_PlaintiffAttorney]
WHERE planAtorneyContactID is not null
) 

UPDATE [sma_MST_OrgContacts] SET connContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Law Firm' and octnContactCtgID=2)
WHERE connContactID in
(
SELECT DISTINCT planLawfrmContactID FROM [sma_TRN_PlaintiffAttorney]
WHERE planLawfrmContactID is not null
)


----(3)----

UPDATE [sma_MST_IndvContacts] SET cinnContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Attorney' and octnContactCtgID=1)
WHERE cinnContactID in
(
SELECT DISTINCT lwfnAttorneyContactID from [sma_TRN_LawFirms]
WHERE lwfnAttorneyContactID is not null
)

UPDATE [sma_MST_OrgContacts] SET connContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Law Firm' and octnContactCtgID=2)
WHERE connContactID in
(
SELECT DISTINCT lwfnLawFirmContactID FROM [sma_TRN_LawFirms]
WHERE lwfnLawFirmContactID is not null
)


----(4)----
UPDATE [sma_MST_IndvContacts] SET cinnContactTypeID=(SELECT octnOrigContactTypeID FROM [sma_MST_OriginalContactTypes] WHERE octsDscrptn='Judge')
FROM
( SELECT DISTINCT judge_link FROM NeedlesKMY.[dbo].[cases] ) A
WHERE A.judge_link=saga and isnull(saga,0)<>0 



------
ALTER TABLE sma_MST_OrgContacts ENABLE TRIGGER ALL
GO
ALTER TABLE sma_MST_IndvContacts ENABLE TRIGGER ALL
GO
-----
