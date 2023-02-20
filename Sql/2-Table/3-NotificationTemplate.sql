IF OBJECT_ID('ed.NotificationTemplate', 'U') IS NULL 
BEGIN
CREATE TABLE [ed].[NotificationTemplate](
	ID [int] IDENTITY(1,1) NOT NULL,
	IsActive BIT DEFAULT 1,
	[Description] [nvarchar](100) NULL,
	[Type] INT NOT NULL,
	[Priority] INT NOT NULL,
	[Role] [uniqueidentifier],
	Process NVARCHAR(100),
	TemplateSubject NVARCHAR(500),
	TemplateBody NVARCHAR(MAX),
	IsDefault BIT,
	PRIMARY KEY (ID),
	FOREIGN KEY (Type) REFERENCES ed.NotificationType(ID)
)
END;
DECLARE @ActionListId INT = (SELECT Id from ed.NotificationType WHERE Code = 'ActionList')
DECLARE @MissingTimeId INT = (SELECT Id from ed.NotificationType WHERE Code = 'MissingTime')
--default action list
INSERT INTO [ed].[NotificationTemplate] 
	SELECT 
		1 --IsActive
		,'default notification template- action list' -- Description
		,@ActionListId -- Type
		,1 --Priority
		,NULL -- Role
		,NULL -- Process
		,'default notification template- action list - subject' -- TemplateSubject
		,'Dear @UserName, The Process @ProcessName is waiting for your action since @lastAccessTime, Please finalize it ASAP' -- TemplateBody
		,1 -- IsDefault
	WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationTemplate] WHERE Description = 'default notification template- action list');

--default missing time
INSERT INTO [ed].[NotificationTemplate] 
	SELECT 
		1 --IsActive
		,'default notification template- missing time' -- Description
		,@MissingTimeId -- Type
		,1 --Priority
		,NULL -- Role
		,NULL -- Process
		,'default notification template- missing time - subject' -- TemplateSubject
		,'Dear @UserName, You logged @LoggedHours hours the week of @WeekName. You''re missing @MissingHours out of @RequiredHours.' -- TemplateBody
		,1 -- IsDefault
	WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationTemplate] WHERE Description = 'default notification template- missing time');