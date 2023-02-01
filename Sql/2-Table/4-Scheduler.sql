IF OBJECT_ID('ed.Scheduler', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[Scheduler](
	ID [int] IDENTITY(1,1) NOT NULL,
	CronExpression NVARCHAR(200),
	Description NVARCHAR(200),
	PRIMARY KEY (ID),
)
END;