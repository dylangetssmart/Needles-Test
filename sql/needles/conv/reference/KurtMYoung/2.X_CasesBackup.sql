-- Declare variables
DECLARE @currentTimestamp NVARCHAR(20);
SET @currentTimestamp = FORMAT(GETDATE(), 'yyyy-MM-dd_HH-mm');
DECLARE @prefix NVARCHAR(10) = '2.X_';
DECLARE @step NVARCHAR(10) = 'Cases';
DECLARE @databaseName1 sysname = 'NeedlesKMY';
DECLARE @databaseName2 sysname = 'SANeedlesKMY';
DECLARE @directory NVARCHAR(128) = 'C:\LocalConv\NeedlesKMY\backups\';

-- Specify the backup file paths with timestamp
DECLARE @backupPath1 NVARCHAR(255) = @directory + @prefix + @databaseName1 + '_After' + @step + '_' + @currentTimestamp + '.bak';
DECLARE @backupPath2 NVARCHAR(255) = @directory + @prefix + @databaseName2 + '_After' + @step + '_' + @currentTimestamp + '.bak';

-- Backup first database
DECLARE @backupCommand1 NVARCHAR(MAX);
SET @backupCommand1 = 'BACKUP DATABASE [' + @databaseName1 + '] TO DISK = ''' + @backupPath1 + ''' WITH FORMAT, INIT, NAME = ''' + @databaseName1 + ' Full Backup'', SKIP, NOREWIND, NOUNLOAD, STATS = 10';
EXEC sp_executesql @backupCommand1;

-- Backup second database
DECLARE @backupCommand2 NVARCHAR(MAX);
SET @backupCommand2 = 'BACKUP DATABASE [' + @databaseName2 + '] TO DISK = ''' + @backupPath2 + ''' WITH FORMAT, INIT, NAME = ''' + @databaseName2 + ' Full Backup'', SKIP, NOREWIND, NOUNLOAD, STATS = 10';
EXEC sp_executesql @backupCommand2;
