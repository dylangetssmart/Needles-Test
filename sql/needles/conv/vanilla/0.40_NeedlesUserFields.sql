-- Use TestNeedles
-- GO

IF EXISTS (Select * From sys.tables where name = 'NeedlesUserFields' and type = 'U')
BEGIN
	DROP TABLE NeedlesUserFields
END

-------------------------------------------
--CREATE TABLE NEEDLES USER FIELDS
-------------------------------------------
CREATE TABLE NeedlesUserFields
( 
	field_num			int
	,field_title		varchar(30)
	,column_name		varchar(30)
	,field_Type			varchar(20)
	,field_len			varchar(10)
	,mini_Dir			varchar(50)
	,UDFType			varchar(30)
	,DropDownValues		varchar(max)
)
-------------------------------------------------------------------
--BUILD USER FIELDS PLUS DROP DOWNS FOR UDF DEFINITION PURPOSES
-------------------------------------------------------------------
INSERT INTO NeedlesUserFields
(
	field_num
	,field_title
	,column_name
	,field_Type
	,field_len
	,mini_Dir
	,UDFType
)
SELECT field_num, field_title, column_name,  field_type, 
	case
		when field_Type in ('number','money') then convert(varchar,field_len) + ',2'
		else convert(varchar,field_len)
	end,
	Mini_Dir_Title,
	case
		when field_Type in ('name', 'alpha', 'state','valuecode','staff') then 'Text'
		when field_Type in ('number', 'money') then 'Number'
		when field_Type in ('boolean', 'checkbox') then 'CheckBox'
		when field_Type = 'minidir' then 'Dropdown'
		when field_Type = 'Date' then 'Date'
		when field_Type = 'Time' then 'Time'
		else field_type
	end
--Select *
FROM TestNeedles..[user_case_fields]


-----------------------------------------------------
--CURSOR TO FILL IN DROP DOWN VALUES FOR MINI DIRS
-----------------------------------------------------
DECLARE @miniDir varchar(30),
		@fieldTitle	varchar(50),
		@numberCt int,
		@code varchar(30)

DECLARE userFields_cursor CURSOR FOR
SELECT Mini_Dir, field_title from NeedlesUserFields where field_type = 'minidir'

OPEN userFields_Cursor
FETCH NEXT FROM userFields_Cursor INTO @miniDir, @fieldTitle
WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT identity(int,1,1) as Number, gd.code
	INTO #values
	FROM TestNeedles..mini_general_dir gd
	JOIN TestNeedles..mini_dir_list dl on gd.num_assigned = dl.dir_key
	WHERE dir_name = @miniDir  


	SET @numberCt = (select max(number) from #values)

	WHILE @numberCt >= 1
	BEGIN
		
		SET @code = (select code from #values where Number = @numberCt)

		UPDATE NeedlesUserFields
		SET DropDownValues = case when dropDownValues is null then @code else DropDownValues + '~'+@code end
		WHERE Mini_Dir = @miniDir
		and field_title = @fieldTitle

		SET @numberCt = @numberCt - 1
		
	END
	
	DROP TABLE #values

FETCH NEXT FROM userFields_Cursor INTO @miniDir, @fieldTitle
END
CLOSE userFields_Cursor;
DEALLOCATE userFields_Cursor;


--select * from NeedlesUserFields

/*
select dl.dir_name, item_id, gd.code
from TestNeedles..mini_general_dir gd
JOIN TestNeedles..mini_dir_list dl on gd.num_assigned = dl.dir_key
where dir_name = 'Living with'  --(Field_title)
*/