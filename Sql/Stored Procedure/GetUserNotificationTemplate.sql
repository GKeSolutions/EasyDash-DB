IF OBJECT_ID('[ed].[GetUserNotificationTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetUserNotificationTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE ed.GetUserNotificationTemplate
		@Process NVARCHAR(500),
		@EventType NVARCHAR(100),
		@UserId uniqueidentifier
	AS
	BEGIN
		IF(@Process='ActionList')
		BEGIN
			IF EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND Process=@Process)
			BEGIN
				If EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND Process=@Process AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)))
					SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND Process=@Process AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)) Order By Priority
				ELSE 
					IF EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND Process=@Process and Role Is NULL)
						SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND Process=@Process AND Role IS NULL Order By Priority
					ELSE SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND IsDefault=1
			END
			ELSE 
				SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='ActionList' AND IsDefault=1
		END
		ELSE 
		BEGIN
			IF(@Process='MissingTime')
			BEGIN
				If EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type='MissingTime' AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)))
					SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='MissingTime' AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)) Order By Priority
				ELSE
					SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type='MissingTime' AND IsDefault=1
			END
		END
	END
GO
