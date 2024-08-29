
---------------------------------------
--MATTER CODES AND COUNTS
---------------------------------------
select m.*, [count]
from matter m
JOIN (
select m.matcode, m.header, m.[description], count(*) as [Count]
from matter m
join cases_Indexed ci on m.matcode = ci.matcode
GROUP BY m.matcode, m.header, m.[description] ) c on m.matcode = c.matcode

-------------------------------
--MINI DIR LISTS
-------------------------------
select dl.dir_name, gd.*
from mini_general_dir gd
JOIN mini_dir_list dl on gd.num_assigned = dl.dir_key

-----------------------------
--VALUE CODES
-----------------------------
select * From value_code

------------------------
--CLASS
------------------------
select * From Class



------------------
--PARTY ROLES
------------------
select [role], count(*) as Count
from party_Indexed
where isnull([role],'') <> ''
GROUP BY [role]