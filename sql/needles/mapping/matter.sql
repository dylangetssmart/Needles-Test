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