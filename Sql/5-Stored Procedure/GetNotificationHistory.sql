IF OBJECT_ID('[ed].[GetNotificationHistory]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetNotificationHistory] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER Procedure [ed].[GetNotificationHistory]
	@ActionType INT
AS
BEGIN
	IF @ActionType = 1
		SELECT
			'User Name' UserName
			, InsertDate [Date]
			, IsReassign
			, ReassignTo
			, TriggeredBy
			, ProcessDescription
			, 'Open Since' OpenSince
			, [Subject]
			, Content
		FROM ed.NotificationHistory
	ELSE IF @ActionType = 2
		SELECT
			'User Name' UserName
			, InsertDate [Date]
			, TriggeredBy
			, RequiredHours
			, LoggedHours
			, MissingHours
			, [Subject]
			, Content
		FROM ed.NotificationHistory
END
GO
