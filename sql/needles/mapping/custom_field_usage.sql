 SELECT 
	[field_num]
     ,[field_num_location]
     ,[field_title]
     ,[field_type]
     ,[field_len]
     ,[mini_dir_id]
     ,[mini_dir_title]
     ,cfu.[column_name]
     ,[mini_dir_id_location]
     ,cfu.[tablename]
     ,[caseid]
     ,[ValueCount]
	 ,CFSD.field_value AS [Sample Data]
FROM 
    CustomFieldUsage CFU
	LEFT JOIN CustomFieldSampleData CFSD
		ON CFU.column_name = CFSD.column_name
		AND CFU.tablename = CFSD.tablename
order by CFU.tablename, CFU.field_num