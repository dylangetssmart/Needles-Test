-- USE TestNeedles
-- GO

/**************************************************
 * Functions:
 *	dbo.myvarchar
 *	dbo.get_firstword
 *	dbo.get_lastword
 *	dbo.GetContactCtg
 *	dbo.MoneyToDecimal
 *	dbo.my_smalldatetime
 *	dbo.Integer2Date
 *	dbo.fn_ConvertToDateTime
 *	dbo.LeftWord
 *	dbo.FirstName_FromText
 *	dbo.MiddleName_FromText
 *	dbo.LastName_FromText
 *	dbo.Dworkin_FirstName_FromText
 *	dbo.Dworkin_LastName_FromText
 **************************************************/

-----
ALTER TABLE [sma_MST_OrgContacts] ALTER COLUMN [saga] varchar(100)
GO
ALTER TABLE [sma_MST_IndvContacts] ALTER COLUMN [cinsGrade] varchar(60)
GO

-----

IF OBJECT_ID (N'dbo.myvarchar', N'FN') IS NOT NULL
    DROP FUNCTION myvarchar;
GO
CREATE FUNCTION dbo.myvarchar(@DateParameter varchar(100) )
RETURNS varchar(100) 
AS 

BEGIN
    DECLARE @ret varchar(100);
	SELECT @ret=@DateParameter;
    RETURN @ret;
END;
GO


IF OBJECT_ID (N'dbo.get_firstword', N'FN') IS NOT NULL
    DROP FUNCTION get_firstword;
GO
CREATE FUNCTION dbo.get_firstword(@WordParameter varchar(100) )
RETURNS varchar(100) 
AS 

BEGIN
    DECLARE @ret varchar(100);
	SELECT @ret=(select top 1 data from dbo.split(RTRIM(LTRIM(convert(varchar,@WordParameter))) ,' ') order by ID  asc);
    RETURN @ret;
END;
GO

IF OBJECT_ID (N'dbo.get_lastword', N'FN') IS NOT NULL
    DROP FUNCTION get_lastword;
GO
CREATE FUNCTION dbo.get_lastword(@WordParameter varchar(100) )
RETURNS varchar(100) 
AS 

BEGIN
    DECLARE @ret varchar(100);
	SELECT @ret=(select top 1 data from dbo.split(RTRIM(LTRIM(convert(varchar,@WordParameter))) ,' ') order by ID  desc);
    RETURN @ret;
END;
GO


/*
Single word - Organization
Two words - individual FirstName LastName
Three words with the second one as single letter with the period - FirstName M. LastName
Everything else - Organization
*/
IF OBJECT_ID (N'dbo.GetContactCtg', N'FN') IS NOT NULL
    DROP FUNCTION GetContactCtg;
GO
CREATE FUNCTION dbo.GetContactCtg(@name varchar(500) )
RETURNS int 
AS 
BEGIN
    DECLARE @ret int;

	DECLARE @wc int=0;
	SELECT @wc=count(*) from dbo.split(@name,' ') 

	IF @wc = 1
	BEGIN
		SET @ret=2;
	END 

	IF @wc = 2
	BEGIN
		SET @ret=1;
	END 

	IF @wc = 3 
	BEGIN
		IF EXISTS (select * from dbo.split(@name,' ') where ID=2 and Data like '_.')
		BEGIN
			SET @ret=1;
		END
		ELSE BEGIN
			SET @ret=2;
		END
	END

	IF @wc >= 4 
	BEGIN
		SET @ret=2;
	END

    RETURN @ret;
END;
GO

IF OBJECT_ID (N'dbo.MoneyToDecimal', N'FN') IS NOT NULL
    DROP FUNCTION MoneyToDecimal;
GO
CREATE FUNCTION dbo.MoneyToDecimal(@WordParameter varchar(100) )
RETURNS decimal(18,2) 
AS 
BEGIN
    DECLARE @ret decimal(18,2);
	IF isnull(@WordParameter,'')<>''
	BEGIN
		SELECT @ret=replace(replace(@WordParameter,'$',''),',','')
	END
	ELSE BEGIN
		SELECT @ret=0.0
	END
    RETURN @ret;
END;
GO

/*
IF OBJECT_ID (N'dbo.GetDWorkinContactCtg', N'FN') IS NOT NULL
    DROP FUNCTION GetDWorkinContactCtg;
GO
CREATE FUNCTION dbo.GetDWorkinContactCtg(@name varchar(MAX) )
RETURNS int 
AS 
BEGIN
    DECLARE @ret int;
		
		set @ret=1;
	if exists ( select * from [TimeMattersMcCoy].[lntmu11].[contact] CT where org='O' and full_name=@name)
	begin
		set @ret=2;
	end
    RETURN @ret;
END;
GO
*/

IF OBJECT_ID (N'dbo.my_smalldatetime', N'FN') IS NOT NULL
    DROP FUNCTION my_smalldatetime;
GO
CREATE FUNCTION dbo.my_smalldatetime(@WordParameter varchar(100) )
RETURNS smalldatetime 
AS 

BEGIN
    DECLARE @ret smalldatetime;
	SET @ret = convert(smalldatetime,@WordParameter);
    RETURN @ret;
END
GO


--example:
--select dbo.Integer2DateTime(75293, 75293 ); --2007-02-19 00:13:00
--select dbo.Integer2DateTime(77246, 4254001 ); --2012-06-25 11:49:00
--SELECT dbo.Integer2DateTime(36163,0); --1900-01-01 00:00:00
IF OBJECT_ID (N'dbo.Integer2DateTime', N'FN') IS NOT NULL
    DROP FUNCTION Integer2DateTime;
GO

-- CREATE FUNCTION dbo.Integer2DateTime( @intDate int, @intTime int )
-- RETURNS smalldatetime 
-- AS 

-- BEGIN
-- 	DECLARE @ret smalldatetime;
-- 	DECLARE @date date;
-- 	DECLARE @time time;

-- 	SELECT @date = cast(dateadd(day,@intDate,'1800-12-28') as date)

-- 	SELECT @time = cast(dateadd(second,@intTime/100,'1800-12-28 00:00:00') as time)

-- 	SET @ret= @date + cast(@time as smalldatetime);

--     RETURN @ret;
-- END
CREATE FUNCTION dbo.Integer2DateTime( @intDate int, @intTime int )
RETURNS datetime 
AS 
BEGIN
    DECLARE @ret datetime;
    DECLARE @date datetime;
    DECLARE @time datetime;

    -- Convert intDate to date
    SET @date = DATEADD(day, @intDate, '1800-12-28')

    -- Convert intTime to time (as smalldatetime)
    SET @time = CAST(DATEADD(second, @intTime / 100, '1800-12-28 00:00:00') AS smalldatetime)

    -- Combine date and time
    SET @ret = DATEADD(day, DATEDIFF(day, '19000101', @date), @time)

    RETURN @ret;
END
GO

CREATE FUNCTION dbo.Integer2Date( @intDate int)
RETURNS date 
AS 

BEGIN
	DECLARE @date date;

	SELECT @date = cast(dateadd(day,@intDate,'1800-12-28') as date)

    RETURN @date;
END
GO



-- Unix Timestamp:

IF OBJECT_ID (N'dbo.fn_ConvertToDateTime', N'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_ConvertToDateTime;
GO

CREATE FUNCTION dbo.fn_ConvertToDateTime (@Datetime BIGINT)
RETURNS DATETIME
AS
BEGIN
    DECLARE @LocalTimeOffset BIGINT
           ,@AdjustedLocalDatetime BIGINT;
    SET @LocalTimeOffset = DATEDIFF(second,GETDATE(),GETUTCDATE())
    SET @AdjustedLocalDatetime = @Datetime - @LocalTimeOffset
    RETURN (SELECT DATEADD(second,@AdjustedLocalDatetime, CAST('1970-01-01 00:00:00' AS datetime)))
END;

GO
---example:
---select dbo.LeftWord('WE 2013/12/3') -- WE

IF OBJECT_ID (N'dbo.LeftWord', N'FN') IS NOT NULL
    DROP FUNCTION LeftWord;
GO

CREATE FUNCTION dbo.LeftWord( @string varchar(MAX) )
RETURNS varchar(MAX) 
AS 
BEGIN
DECLARE @Ret varchar(MAX);

SET @string=rtrim(ltrim(@string))

IF (CHARINDEX(' ', @string) = 0 ) 
BEGIN
	set @Ret=@string
END
ELSE
BEGIN
	SET @Ret=LEFT(@string, CHARINDEX(' ', @string)-1)
END
	RETURN @Ret
END

GO


---
IF OBJECT_ID (N'dbo.FirstName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION FirstName_FromText;
GO

CREATE FUNCTION dbo.FirstName_FromText( @Str varchar(MAX) )
RETURNS varchar(MAX) 
AS 
BEGIN

DECLARE @Ret varchar(MAX);

SET  @Str=rtrim(ltrim(@Str));

IF CHARINDEX(',', @Str) <> 0
	BEGIN
		SET @Ret = right(@Str,len(@Str)-CHARINDEX(',', @Str));
	END  

ELSE
	BEGIN

	IF (CHARINDEX(' ', @Str) = 0 ) 
		BEGIN
			IF ISDATE(@Str)=1
				BEGIN
					SET @Ret=null;
				END
			ELSE
				BEGIN
					SET @Ret=@Str  -- 1 word
				END
		END
	ELSE
		BEGIN
			SET @Ret=LEFT(@Str, CHARINDEX(' ', @Str)-1)
		END
	END

	RETURN @Ret;

END

GO


----------------------------
IF OBJECT_ID (N'dbo.LastName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION LastName_FromText;
GO

CREATE FUNCTION dbo.LastName_FromText( @Str varchar(MAX) )
RETURNS varchar(MAX) 
AS 
BEGIN

DECLARE @Ret varchar(MAX);

SET  @Str=rtrim(ltrim(@Str));

IF CHARINDEX(',', @Str) <> 0
	BEGIN
		SET @Ret = LEFT(@Str,CHARINDEX(',', @Str)-1);
	END  

ELSE
	BEGIN

	IF (CHARINDEX(' ', @Str) = 0 ) 
		BEGIN
			IF ISDATE(@Str)=1
				BEGIN
					SET @Ret=null;
				END
			ELSE
				BEGIN
					SET @Ret=@Str  -- 1 word
				END
		END
	ELSE
		BEGIN
			SET @Ret=RIGHT(@Str, LEN(@Str)-CHARINDEX(' ', @Str))
		END
	END

	RETURN @Ret;

END

GO

------------------
------------------
------------------

IF OBJECT_ID (N'dbo.FirstName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION dbo.FirstName_FromText;
GO

CREATE FUNCTION dbo.FirstName_FromText( @StringParameter varchar(100) )
RETURNS varchar(100) 
AS 
BEGIN

	DECLARE @Result varchar(100)='';
    DECLARE @WordCount int;

	IF CHARINDEX(',',@StringParameter) > 0
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,',') WHERE ID=2
		RETURN @Result
	END


	IF CHARINDEX('&',@StringParameter) > 0
	BEGIN
		SELECT @StringParameter=substring(@StringParameter,0, CHARINDEX('&',@StringParameter))
	END

	SELECT @WordCount=count(Data) from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') 

	IF @WordCount >= 1
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=1
	END

	RETURN @Result;

END

GO

--
IF OBJECT_ID (N'dbo.MiddleName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION dbo.MiddleName_FromText;
GO

CREATE FUNCTION dbo.MiddleName_FromText( @StringParameter varchar(100) )
RETURNS varchar(100) 
AS 
BEGIN

	DECLARE @Result varchar(100)='';
    DECLARE @WordCount int;

	IF CHARINDEX('&',@StringParameter) > 0
	BEGIN
		SELECT @StringParameter=substring(@StringParameter,0, CHARINDEX('&',@StringParameter))
	END

	SELECT @WordCount=count(Data) from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') 

	IF @WordCount >= 3
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=2
	END
	RETURN @Result;

END

GO

--
IF OBJECT_ID (N'dbo.LastName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION dbo.LastName_FromText;
GO

CREATE FUNCTION dbo.LastName_FromText( @StringParameter varchar(100) )
RETURNS varchar(100) 
AS 
BEGIN

	DECLARE @Marker varchar(100);
	DECLARE @Result varchar(100)=''
    DECLARE @WordCount int;

	IF CHARINDEX(',',@StringParameter) > 0
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,',') WHERE ID=1
		RETURN @Result
	END

	IF CHARINDEX('&',@StringParameter) > 0
	BEGIN
		SELECT @StringParameter=substring(@StringParameter,0, CHARINDEX('&',@StringParameter))
	END


	SELECT @WordCount=count(Data) from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') 

	IF @WordCount > 3
	BEGIN
		SELECT @Marker=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=3
		SELECT @Result=SUBSTRING( @StringParameter ,CHARINDEX ( @Marker,@StringParameter),len(@StringParameter))
	END
	ELSE IF @WordCount = 3
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=3
	END
	ELSE
	BEGIN 
		IF @WordCount = 2
		BEGIN
			SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=2
		END
	END
	RETURN @Result

END

GO



------------------

GO

------

IF OBJECT_ID (N'dbo.Dworkin_FirstName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION dbo.Dworkin_FirstName_FromText;
GO

CREATE FUNCTION dbo.Dworkin_FirstName_FromText( @StringParameter varchar(100) )
RETURNS varchar(100) 
AS 
BEGIN

	DECLARE @Result varchar(100)='';
    DECLARE @WordCount int;


	IF CHARINDEX('&',@StringParameter) > 0
	BEGIN
		SELECT @StringParameter=substring(@StringParameter,0, CHARINDEX('&',@StringParameter))
	END

	SELECT @WordCount=count(Data) from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') 

	IF @WordCount >= 1
	BEGIN
		SELECT @Result=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=1
	END

	RETURN @Result;

END

GO

------

IF OBJECT_ID (N'dbo.Dworkin_LastName_FromText', N'FN') IS NOT NULL
    DROP FUNCTION dbo.Dworkin_LastName_FromText;
GO

CREATE FUNCTION dbo.Dworkin_LastName_FromText( @StringParameter varchar(100) )
RETURNS varchar(100) 
AS 
BEGIN

	DECLARE @Marker varchar(100);
	DECLARE @Result varchar(100)=''
    DECLARE @WordCount int;


	IF CHARINDEX('&',@StringParameter) > 0
	BEGIN
		SELECT @StringParameter=substring(@StringParameter,0, CHARINDEX('&',@StringParameter))
	END


	SELECT @WordCount=count(Data) from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') 

	IF @WordCount >= 2
	BEGIN
		SELECT @Marker=Data from dbo.split(RTRIM(LTRIM(convert(varchar,@StringParameter))) ,' ') WHERE ID=2
		SELECT @Result=SUBSTRING( @StringParameter ,CHARINDEX ( @Marker,@StringParameter),len(@StringParameter))
	END
	RETURN @Result

END

GO

