-------------------------------
--MINI DIR LISTS
-------------------------------
select dl.dir_name, gd.*
from mini_general_dir gd
JOIN mini_dir_list dl on gd.num_assigned = dl.dir_key