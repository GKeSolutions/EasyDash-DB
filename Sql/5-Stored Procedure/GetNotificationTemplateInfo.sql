IF OBJECT_ID('[ed].[GetNotificationTemplateInfo]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetNotificationTemplateInfo] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [ed].GetNotificationTemplateInfo
		@NotificationTemplateId INT
	AS
	BEGIN
		SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Id=@NotificationTemplateId
	END
GO
