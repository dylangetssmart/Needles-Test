
USE [SANeedlesKMY]
GO


---(1)---
DELETE FROM sma_MST_CaseTypeDefualtDefs

---(2)---
INSERT INTO sma_MST_CaseTypeDefualtDefs
SELECT DISTINCT 
    CST.cstnCaseTypeID		  as cddnCaseTypeID,
    I.cinnContactID			  as cddnDefContatID,
    I.cinnContactCtg		  as cddnDefContactCtgID,
    sbrnSubRoleId			  as cddnRoleID,
    A.addnAddressID			  as cddnDefAddressID
FROM sma_mst_casetype CST
JOIN sma_mst_SubRole S on sbrnCaseTypeID=CST.cstnCaseTypeID 
JOIN sma_mst_SubRoleCode STC on S.sbrnTypeCode=STC.srcnCodeId and STC.srcsDscrptn='(D)-Defendant'
CROSS JOIN sma_MST_IndvContacts I
JOIN sma_MST_Address A on A.addnContactID=I.cinnContactID and A.addnContactCtgID=I.cinnContactCtg and A.addbPrimary=1
WHERE CST.VenderCaseType='KMYCaseType'
and I.cinsFirstName='Individual'
and I.cinsLastName='Unidentified'




