------------------
--PARTY ROLES
------------------
select [role], count(*) as Count
from party_Indexed
where isnull([role],'') <> ''
GROUP BY [role]