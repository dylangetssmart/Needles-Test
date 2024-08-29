--drop table CustomFieldUsage

 ---needles custom fields---
select A.*, 0 as ValueCount
INTO CustomFieldUsage
FROM (
	SELECT 
		F.*,
		M.tablename,
		m.caseid--,
		--ROW_NUMBER() over(partition by F.field_num order by F.field_num ) as rowindex
	from [dbo].[user_case_fields] F
	join
		(
		select ref_num,'user_case_data' as tablename, 'casenum' as caseid from [dbo].[user_case_matter] 
		   union
		select ref_num, 'user_tab_data'as tablename, 'case_id'as caseid   from [dbo].[user_tab_matter] 
		   union
		select ref_num, 'user_tab2_data' as tablename, 'case_id'as caseid  from [dbo].[user_tab2_matter] 
		   union
		select ref_num, 'user_tab3_data'as tablename, 'case_id'as caseid  from [dbo].[user_tab3_matter] 
		   union
		select ref_num, 'user_tab4_data' as tablename, 'case_id'as caseid  from [dbo].[user_tab4_matter] 
		   union
		select ref_num, 'user_tab5_data'as tablename, 'case_id' as caseid  from [dbo].[user_tab5_matter] 
		   union
		select ref_num, 'user_tab6_data' as tablename, 'case_id'as caseid  from [dbo].[user_tab6_matter] 
		   union
		select ref_num, 'user_tab7_data' as tablename, 'case_id'as caseid   from [dbo].[user_tab7_matter] 
		   union
		select ref_num, 'user_tab8_data' as tablename, 'case_id'as caseid  from [dbo].[user_tab8_matter] 
		   union
		select ref_num, 'user_tab9_data'as tablename, 'case_id'as caseid   from [dbo].[user_tab9_matter] 
		   union
		select ref_num, 'user_tab10_data' as tablename, 'case_id'as caseid  from [dbo].[user_tab10_matter] 
		   union
		select ref_num, 'user_insurance_data' as tablename, 'casenum'as caseid  from [dbo].[user_case_insurance_matter] 
		   union
		select ref_num, 'user_party_data' as tablename, 'case_id' as caseid  from [dbo].[user_party_matter] 
		   union
		select ref_num, 'user_value_data' as tablename, 'case_id'as caseid  from [dbo].[user_case_value_matter] 
		   union
		select ref_num, 'user_counsel_data' as tablename, 'casenum'as caseid  from [dbo].[user_case_counsel_matter] 
		) M on M.ref_num=F.field_num
	) A-- where A.rowindex=1
order by A.tablename,A.field_num

--select * From CustomFieldUsage

--CURSOR
DECLARE @table varchar(100), 
		@Field varchar(100),
		@caseid varchar(20),
		@DataType varchar(20),
		@sql varchar(5000)

DECLARE FieldUsage_Cursor CURSOR FOR 
SELECT TableName,Column_Name, caseid,Field_Type FROM CustomFieldUsage
 
OPEN FieldUsage_Cursor 
FETCH NEXT FROM FieldUsage_Cursor INTO @table,@field, @caseid,@datatype
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @datatype IN ('varchar','nvarchar','date','datetime2','bit','ntext','datetime','time','Name','alpha','boolean','checkbox','minidir','staff','state','time','valuecode')
	BEGIN
		SET @SQL = 'UPDATE CustomFieldUsage SET ValueCount = ( Select count(*) FROM cases_Indexed ci JOIN [' + @table +'] t on [ci].CaseNum = t.[' + @caseid +'] WHERE isnull(['+@field+'],'''')<>'''') ' +
					'WHERE TableName = '''+@table + ''' and Column_Name = ''' + @Field + ''''
	END
	ELSE IF @datatype IN ('int','decimal','money','float','smallint','tinyint','numeric','bigint','smallint')
	BEGIN

		SET @SQL = 'UPDATE CustomFieldUsage SET ValueCount = ( Select count(*) FROM cases_Indexed ci JOIN [' + @table +'] t on [ci].CaseNum = t.[' + @caseid +'] WHERE isnull(['+@field+'],0)<>0 ) ' + 
					'WHERE TableName = '''+@table + ''' and Column_Name = ''' + @Field + ''''
	END

	exec(@sql)
	--select @sql

	
FETCH NEXT FROM FieldUsage_Cursor INTO @table,@field, @caseid, @datatype
END 
CLOSE FieldUsage_Cursor;
DEALLOCATE FieldUsage_Cursor;


SELECT * FROM CustomFieldUsage
order by tablename, field_num

