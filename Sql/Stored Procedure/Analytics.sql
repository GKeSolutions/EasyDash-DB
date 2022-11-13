CREATE PROCEDURE [dbo].[Analytics] 
	@StartDate DateTime
	, @EndDate DateTime
AS
BEGIN
SELECT 
	AppObject.AppObjectCode ProcessCode, 
	msg.Msg ProcessName,
	currentUserid UserId, 
	baseuser.BaseUserName UserName,
	--If the Task started after the @StartDate, use the @startdate to calculate the hours, so we don't include time spent before the report Startdate
	--If the Task ended after the @EndDate, use the @Enddate to calculate the hours, so we don't include time spent after the report Enddate
	SUM(DATEDIFF(
				HOUR, 
				Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
				Case When ISNULL(step.EndDateTime, GETDATE()) >= @EndDate Then @EndDate Else step.EndDateTime End
				)
		)/Count(1) AvgTimeSpentInhours, --Returns the average time spent per user per process
	SUM(DATEDIFF(
				MINUTE,
				Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
				Case When ISNULL(step.EndDateTime, GETDATE()) >= @EndDate Then @EndDate Else step.EndDateTime End
				)
		)/Count(1) AvgTimeSpentInMinutes, --Returns the average time spent per user per process
	SUM(DATEDIFF(
				MINUTE,
				Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
				Case When ISNULL(step.EndDateTime, GETDATE()) >= @EndDate Then @EndDate Else step.EndDateTime End
				)) TotalTimeSpentInMinutes
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
	AND DATEDIFF(MINUTE, step.StartDateTime, ISNULL(step.EndDateTime, GETDATE())) > 0
	And step.StartDateTime < @EndDate
	And ISNULL(step.EndDateTime, GETDATE()) > @StartDate
GROUP BY 
	AppObject.AppObjectCode, 
	msg.Msg,
	currentUserid, 
	baseuser.BaseUserName
--Return only record with Average hours higher than 0.1
HAVING 
	SUM(DATEDIFF(
			HOUR, 
			Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
			Case When ISNULL(step.EndDateTime, GETDATE()) >= @EndDate Then @EndDate Else step.EndDateTime End
			)
	)/Count(1) > 0.1
ORDER BY currentUserid, SUM(DATEDIFF(
			MINUTE, 
			Case When step.StartDateTime < @StartDate Then @StartDate Else step.StartDateTime End, 
			Case When ISNULL(step.EndDateTime, GETDATE()) >= @EndDate Then @EndDate Else step.EndDateTime End
			)
	)/Count(1) desc
END