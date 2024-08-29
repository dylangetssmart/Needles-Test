--drop table CustomFieldUsage_intake
select distinct
    m.ref_num as field_num,
	m.ref_num_location, 
	m.field_title, 
	replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace( replace( replace (replace(field_Title, '(', ''), ')', ''), ' ','_'), '.',''),'?',''),',',''), '-',''),'~',''),'\',''),'/',''),'''',''),'&',''),':',''),'`','') as column_name,
	field_type,
    'case_intake' as tablename,
	0 as ValueCount
INTO CustomFieldUsage_intake
from [dbo].[user_case_intake_matter] m
WHERE field_type <> 'label'

--CURSOR
DECLARE @table varchar(100), 
		@Field varchar(100),
		@DataType varchar(20),
		@sql varchar(5000)

DECLARE FieldUsage_Cursor CURSOR FOR 
SELECT TableName,Column_Name,Field_Type FROM CustomFieldUsage_intake
 
OPEN FieldUsage_Cursor 
FETCH NEXT FROM FieldUsage_Cursor INTO @table,@field,@datatype
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @datatype IN ('varchar','nvarchar','date','datetime2','bit','ntext','datetime','time','Name','alpha','boolean','checkbox','minidir','staff','state','time','valuecode')
	BEGIN
		SET @SQL = 'UPDATE CustomFieldUsage_intake SET ValueCount = ( Select count(*) FROM [' + @table +'] t WHERE isnull(['+@field+'],'''')<>'''') ' +
					'WHERE TableName = '''+@table + ''' and Column_Name = ''' + @Field + ''''
	END
	ELSE IF @datatype IN ('int','decimal','money','float','smallint','tinyint','numeric','bigint','smallint')
	BEGIN

		SET @SQL = 'UPDATE CustomFieldUsage_intake SET ValueCount = ( Select count(*) FROM [' + @table +'] t WHERE isnull(['+@field+'],0)<>0 ) ' + 
					'WHERE TableName = '''+@table + ''' and Column_Name = ''' + @Field + ''''
	END

	exec(@sql)
	--select @sql

	
FETCH NEXT FROM FieldUsage_Cursor INTO @table,@field,@datatype
END 
CLOSE FieldUsage_Cursor;
DEALLOCATE FieldUsage_Cursor;


SELECT * FROM CustomFieldUsage_intake 
order by tablename, field_num

