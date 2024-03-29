IF OBJECT_ID('[ed].[GetNotificationHistory]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetNotificationHistory] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER Procedure [ed].[GetNotificationHistory]
	@ActionType INT,
	@UserId uniqueidentifier=NULL,
	@StartDate DateTime,
	@EndDate DateTime,
	@ProcessCode NVARCHAR(200)=NULL,
	@ProcItemId uniqueidentifier=NULL
AS
BEGIN
	IF @ActionType = 1
		SELECT
			baseUser.BaseUserName UserName
			, hist.InsertDate NotificationDate
			, hist.IsReassign
			, hist.IsCancelProcess
			, reassignUser.BaseUserName ReassignToStr
			, IsNull(triggeredByUser.BaseUserName, 'System') TriggeredByStr
			, hist.TriggeredBy
			, hist.ProcessDescription
			, hist.LastAccessTime OpenSince
			, hist.[Subject]
			, hist.Content
		FROM ed.NotificationHistory hist 
		JOIN dbo.NxBaseUser BaseUser ON baseUser.NxBaseUserID = hist.UserId
		LEFT OUTER JOIN dbo.NxBaseUser reassignUser ON reassignUser.NxBaseUserId = hist.Reassignto
		LEFT OUTER JOIN dbo.NxBaseUser triggeredByUser ON triggeredByUser.NxBaseUserId = hist.TriggeredBy
		WHERE (@UserId IS NULL OR hist.UserId = @UserId) AND (@ProcessCode IS NULL OR hist.ProcessCode = @ProcessCode) AND (@ProcItemId IS NULL OR hist.ProcItemId = @ProcItemId) AND EventType=1 AND hist.InsertDate > @StartDate AND hist.InsertDate < @EndDate
		Order by hist.InsertDate desc, baseUser.BaseUserName
	ELSE IF @ActionType = 2
		SELECT
			baseUser.BaseUserName UserName
			, IsNull(triggeredByUser.BaseUserName, 'System') TriggeredByStr
			, hist.InsertDate NotificationDate
			, hist.TriggeredBy
			, hist.RequiredHours
			, hist.LoggedHours
			, hist.MissingHours
			, hist.[Subject]
			, hist.Content
		FROM ed.NotificationHistory hist
		JOIN dbo.NxBaseUser BaseUser ON baseUser.NxBaseUserID = hist.UserId
		LEFT OUTER JOIN dbo.NxBaseUser triggeredByUser ON triggeredByUser.NxBaseUserId = hist.TriggeredBy
		WHERE (@UserId IS NULL OR hist.UserId = @UserId) AND EventType=2 AND hist.InsertDate > @StartDate AND hist.InsertDate < @EndDate
		Order by hist.InsertDate desc, baseUser.BaseUserName
END
GO