IF OBJECT_ID('[ed].[AnalyticsDrillDown]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[AnalyticsDrillDown] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [ed].[AnalyticsDrillDown] 
		@user uniqueidentifier
		, @processCode nvarchar
	AS
	BEGIN
	SELECT 
		AppObject.AppObjectCode ProcessCode
		, msg.Msg ProcessName
		, item.Description ProcessDescription
		, item.ProcItemID
		, currentUserid UserId
		, baseuser.BaseUserName UserName
		, Case When step.CurrentStepID like '%_Cancel_%'
			Then 'Cancel'
			Else Replace(step.CurrentStepID, '_Else_End', '') END
		, step.StartDateTime
		, step.EndDateTime
	FROM dbo.NxFWKProcessItemstep step
		JOIN dbo.NxFWKProcessItem item ON item.ProcItemID = step.ProcItemId
		JOIN dbo.NxBaseUser baseuser ON baseuser.Nxbaseuserid = step.CurrentUserId
		JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = item.ProcCode
		JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
		JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
	WHERE ObjectType.AppObjectTypeCode = 'Process'
		AND AppObject.AppObjectCode = @processCode
		AND step.CurrentStepID not like '%_Success_%' --filtering out system steps
		AND EXISTS 
			(SELECT TOP 1 step1.ProcItemStepID 
			FROM dbo.NxFWKProcessItemStep step1 
			WHERE step1.ProcItemID = step.ProcItemID
			AND step1.CurrentUserId = @user)
	ORDER BY item.ProcItemID, step.StartDateTime
END
