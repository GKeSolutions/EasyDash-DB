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
			, hist.InsertDate
			, hist.IsReassign
			, hist.ReassignTo
			, hist.TriggeredBy
			, hist.ProcessDescription
			, hist.LastAccessTime OpenSince
			, hist.[Subject]
			, hist.Content
		FROM ed.NotificationHistory hist 
		WHERE EventType=1
	ELSE IF @ActionType = 2
		SELECT
			'User Name' UserName
			, hist.InsertDate
			, hist.TriggeredBy
			, hist.RequiredHours
			, hist.LoggedHours
			, hist.MissingHours
			, hist.[Subject]
			, hist.Content
		FROM ed.NotificationHistory hist
		WHERE EventType=2
END
GO
