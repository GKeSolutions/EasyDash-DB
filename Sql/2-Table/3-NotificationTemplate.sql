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

--default
INSERT INTO [ed].[NotificationTemplate] SELECT 1 ,'default notification template- action list',(SELECT Id from ed.NotificationType WHERE Code = 'ActionList'),1,NULL,'test process','default notification template- action list - subject','Dear @UserName, The Process @ProcessName is waiting for your action since @lastAccessTime, Please finalize it ASAP',1 WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationTemplate] WHERE Description = 'default notification template- action list');
-- null process
INSERT INTO [ed].[NotificationTemplate] SELECT 1,'null process template - action list',(SELECT Id from ed.NotificationType WHERE Code = 'ActionList'),2,'6038B9CE-CF1F-4E29-A4E2-159EB7318868',NULL,'null process template - action list - subject','Dear @UserName, The Process @ProcessName is waiting for your action since @lastAccessTime, Please finalize it ASAP',0 WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationTemplate] WHERE Description = 'null process template - action list');
-- null role
INSERT INTO [ed].[NotificationTemplate] SELECT 1,'null role template - action list',(SELECT Id from ed.NotificationType WHERE Code = 'ActionList'),2,NULL,'test process','null role template - action list - subject','Dear @UserName, The Process @ProcessName is waiting for your action since @lastAccessTime, Please finalize it ASAP',0 WHERE NOT EXISTS (SELECT 1 FROM [ed].[NotificationTemplate] WHERE Description = 'null role template - action list');