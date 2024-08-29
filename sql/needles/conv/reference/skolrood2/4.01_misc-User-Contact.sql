-- USE [SANeedlesSLF]
GO
/*
update sma_MST_IndvContacts set cinsComments = NULL

*/

---
ALTER TABLE sma_MST_IndvContacts DISABLE TRIGGER ALL
GO
---

----(1)----

--update sma_MST_IndvContacts set cinnMaritalStatusID=A.StatusID
--from
--(
--select  
--    party_id as PartyID,    
--case
--    when P.Marital_Status='Significant Other' then (select mtsnMaritalStatusID FROM [SA].[dbo].[sma_MST_MaritalStatus] where mtssDscrptn = 'Other')
--    else (select mtsnMaritalStatusID FROM [SA].[dbo].[sma_MST_MaritalStatus] where mtssDscrptn = P.Marital_Status)
--end	   as StatusID
--FROM NeedlesSLF.[dbo].[user_party_data] P
--where isnull(P.Marital_Status,'')<>''
--) A
--where A.PartyID  = saga


----(2)-----

UPDATE sma_MST_IndvContacts 
SET cinsSpouse = A.Spouse_Name
FROM
(	SELECT
		P.party_id as PartyID,    
		P.Spouse as Spouse_Name
	FROM NeedlesSLF.[dbo].[user_party_data] P
	WHERE isnull(P.Spouse,'')<>''
) A
WHERE A.PartyID  = saga

---
ALTER TABLE sma_MST_IndvContacts ENABLE TRIGGER ALL
GO
---





/*
----(3)----
update sma_MST_IndvContacts set cinsComments = isnull(cinsComments,'') + CHAR(13) + 'Employment Status : ' + convert(varchar,A.Employment_Status)
from
(
select  
    P.party_id as PartyID,    
    P.Employment_Status as Employment_Status
FROM NeedlesSLF.[dbo].[user_party_data] P
where isnull(P.Employment_Status,'')<>''
) A
where A.PartyID=saga 

select * FROM NeedlesSLF.[dbo].[user_party_data] P
*/

/*
----(5)----
update sma_MST_IndvContacts set cinsComments = isnull(cinsComments,'') + CHAR(13) + 'Length of Employment : ' + convert(varchar,A.Length_of_Employment)
from
(
select  
    P.party_id as PartyID,    
    P.Length_of_Employment as Length_of_Employment
select *
FROM NeedlesSLF.[dbo].[user_party_data] P
where isnull(P.Length_of_Employment,'')<>''
) A
where A.PartyID=saga 
*/

/*
----(6)----
update sma_MST_IndvContacts set cinsComments = isnull(cinsComments,'') + CHAR(13) + 'Payroll Contact : ' + convert(varchar,A.Payroll_Contact)
from
(
select  
    P.party_id as PartyID,    
    P.Payroll_Contact as Payroll_Contact
FROM NeedlesSLF.[dbo].[user_party_data] P
where isnull(P.Payroll_Contact,'')<>''
) A
where A.PartyID=saga 
*/

/*
----(7)----
update sma_MST_IndvContacts set cinsComments = isnull(cinsComments,'') + CHAR(13) + 'Job Duties : ' + convert(varchar,A.Job_Duties)
from
(
select  
    P.party_id as PartyID,    
    P.Job_Duties as Job_Duties
FROM NeedlesSLF.[dbo].[user_party_data] P
where isnull(P.Job_Duties,'')<>''
) A
where A.PartyID=saga 
*/


/*
----(8)----
update sma_MST_IndvContacts set cinsComments = isnull(cinsComments,'') + CHAR(13) + 'Treatment Since Injury : ' + convert(varchar,A.Treatment_Since_Injury)
from
(
select  
    P.party_id as PartyID,    
    P.Treatment_Since_Injury as Treatment_Since_Injury
FROM NeedlesSLF.[dbo].[user_party_data] P
where isnull(P.Treatment_Since_Injury,'')<>''
) A
where A.PartyID=saga 
*/



