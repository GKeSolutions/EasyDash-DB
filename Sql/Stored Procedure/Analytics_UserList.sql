IF OBJECT_ID('[ed].[Analytics_UserList]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[Analytics_UserList] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [dbo].[Analytics_UserList] 
		@StartDate DateTime
		, @EndDate DateTime
	AS
	BEGIN
	SELECT 
		currentUserid UserId, 
		baseuser.BaseUserName UserName
	FROM 
		nxfwkprocessitemstep step
		JOIN dbo.NxFWKProcessItem item ON item.ProcItemID = step.ProcItemId
		JOIN dbo.NxBaseUser baseuser ON baseuser.Nxbaseuserid = step.CurrentUserId
		JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = item.ProcCode
		JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
		JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
	WHERE 
		ObjectType.AppObjectTypeCode = 'Process'
		--AND item.procitemid = '687EA340-B661-4E6C-B965-004B158091A9'
		AND step.StepType <> 0 -- Exclude the "Change Owner" step
		AND DATEDIFF(MINUTE, step.StartDateTime, step.EndDateTime) > 0
		And step.StartDateTime < @EndDate
		And step.EndDateTime > @StartDate
	GROUP BY 
		currentUserid, 
		baseuser.BaseUserName
	--Return only users having procresses Average hours higher than 0.1 -- Same as the main analytics query
	HAVING 
		SUM(DATEDIFF(
				HOUR, 
				Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
				Case When step.EndDateTime > @EndDate Then @EndDate Else step.EndDateTime End
				)
		)/Count(1) > 0.1
	ORDER BY baseuser.BaseUserName
END