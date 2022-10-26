SELECT AppObject.AppObjectCode ProcessCode, msg.Msg ProcessName, item.ProcItemID, currentUserid UserId, baseuser.BaseUserName UserName, step.CurrentStepID, step.StartDateTime, step.EndDateTime,  * 
FROM dbo.NxFWKProcessItemstep step
JOIN dbo.NxFWKProcessItem item ON item.ProcItemID = step.ProcItemId
JOIN dbo.NxBaseUser baseuser ON baseuser.Nxbaseuserid = step.CurrentUserId
JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = item.ProcCode
JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
WHERE ObjectType.AppObjectTypeCode = 'Process'
AND AppObject.AppObjectCode = 'NxBaseUser'
AND EXISTS 
		(SELECT TOP 1 step1.ProcItemStepID 
		FROM dbo.NxFWKProcessItemStep step1 
		WHERE step1.ProcItemID = step.ProcItemID 
		AND step1.CurrentUserId = '251F95C1-3F6E-45F8-8893-A1C2C8678D4E')
ORDER BY item.ProcItemID, step.StartDateTime
