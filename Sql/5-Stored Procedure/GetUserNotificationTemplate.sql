IF OBJECT_ID('[ed].[GetUserNotificationTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetUserNotificationTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [ed].[GetUserNotificationTemplate]
		@Process NVARCHAR(500),
		@EventType INT,
		@UserId uniqueidentifier
	AS
	BEGIN
		DECLARE @EventTypeString NVARCHAR(200) = CASE WHEN @EventType=1 THEN 'ActionList' ELSE 'MissingTime' END
		DECLARE @NotificationType INT = (SELECT Id from ed.NotificationType where Code = @EventTypeString)
		IF(@EventType=1)
		BEGIN
			IF EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Process=@Process)
			BEGIN
				If EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Process=@Process AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)))
					SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Process=@Process AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)) Order By Priority
				ELSE 
					IF EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Process=@Process and Role Is NULL)
						SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Process=@Process AND Role IS NULL Order By Priority
					ELSE SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND IsDefault=1
			END
			ELSE 
				SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND IsDefault=1
		END
		ELSE 
		BEGIN
			IF(@EventType=2)
			BEGIN
				If EXISTS(SELECT 1 FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)))
					SELECT TOP 1 TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND Role IN (SELECT RoleId from ed.GetUserRoles(@UserId)) Order By Priority
				ELSE
					SELECT TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE Type=@NotificationType AND IsDefault=1
			END
		END
	END
GO
