IF OBJECT_ID('ed.Scheduler', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[Scheduler](
	ID [int] IDENTITY(1,1) NOT NULL,
	CronExpression NVARCHAR(200),
	Description NVARCHAR(200),
	PRIMARY KEY (ID),
)
END;
IF NOT EXISTS(SELECT 1 FROM [ed].[Scheduler] WHERE [Description]='Every minute')
	INSERT INTO [ed].[Scheduler] VALUES ('* * * * *' ,'Every minute');
IF NOT EXISTS(SELECT 1 FROM [ed].[Scheduler] WHERE [Description]='Every hour')
	INSERT INTO [ed].[Scheduler] VALUES ('0 * * * * ' ,'Every hour');
