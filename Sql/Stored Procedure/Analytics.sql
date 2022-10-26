CREATE PROCEDURE Analytics 
AS
BEGIN
SELECT 
	AppObject.AppObjectCode ProcessCode, 
	msg.Msg ProcessCaption,
	currentUserid UserId,
	baseuser.BaseUserName UserName,
	SUM(DATEDIFF(HOUR, step.StartDateTime, step.EndDateTime))/Count(1) AvgTimeSpentInhours, --Returns the average time spent per user per process
	SUM(DATEDIFF(MINUTE, step.StartDateTime, step.EndDateTime))/Count(1) AvgTimeSpentInMinutes --Returns the average time spent per user per process
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
GROUP BY 
	AppObject.AppObjectCode, 
	msg.Msg,
	currentUserid, 
	baseuser.BaseUserName
	ORDER BY currentUserid
END
GO
