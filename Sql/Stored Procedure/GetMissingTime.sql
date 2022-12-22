IF OBJECT_ID('[ed].[GetMissingTime]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetMissingTime] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GetMissingTime]
	@StartDate DateTime
	, @EndDate DateTime
AS
BEGIN
SELECT 
	BU.NxBaseUserID UserId, 
	BU.BaseUserName UserName, 
	tkpr.tkprindex TimekeeperIndex, 
	SUM(WorkHrs) WorkHrs, 
	WorkDate, 
	CASE WHEN (	CASE WHEN WC.HoursPerWeek IS NOT NULL THEN WC.HoursPerWeek
				ELSE ISNULL(WC.HoursSunday, 0) + 
						ISNULL(WC.HoursMonday, 0) + 
						ISNULL(WC.HoursTuesday, 0) + 
						ISNULL(WC.HoursWednesday, 0) + 
						ISNULL(WC.HoursThursday, 0) + 
						ISNULL(WC.HoursFriday, 0) + 
						ISNULL(WC.HoursSaturday, 0) END) = 0 
		THEN 40 
		ELSE	CASE WHEN WC.HoursPerWeek IS NOT NULL THEN WC.HoursPerWeek
				ELSE ISNULL(WC.HoursSunday, 0) + 
						ISNULL(WC.HoursMonday, 0) + 
						ISNULL(WC.HoursTuesday, 0) + 
						ISNULL(WC.HoursWednesday, 0) + 
						ISNULL(WC.HoursThursday, 0) + 
						ISNULL(WC.HoursFriday, 0) + 
						ISNULL(WC.HoursSaturday, 0) END 
		END WeeklyHoursRequired, -- When calendar not set or hours required set at the month level, return 40 hours.
	ISNULL(WC.Description, 'Work Cakendar Not Set') Workcalendar
FROM dbo.Timekeeper tkpr
	JOIN Tkprstatus tStatus ON tStatus.Code = tkpr.TkprStatus
	JOIN TkprDate td ON td.TimekeeperLkUp = tkpr.tkprindex AND GETDATE() BETWEEN td.NxStartDate AND td.NxEndDate
	LEFT OUTER JOIN dbo.WorkCalendar WC ON td.WorkCalendar = WC.Code
	JOIN dbo.NxUserTimekeeper UT ON UT.Timekeeper = tkpr.tkprindex AND UT.IsDefault = 1
	JOIN dbo.NxBaseUser BU ON BU.NxBaseUserID = UT.UserID
	JOIN dbo.NxUser U ON U.nxuserid = BU.NxBaseUserID
	LEFT OUTER JOIN dbo.Timecard TC ON Tc.Timekeeper = tkpr.TkprIndex
		AND TC.WorkDate > = @StartDate --StartDate
		AND TC.WorkDate <= @EndDate --EndDate
		AND (TC.IsActive IS NULL OR TC.IsActive = 1)
WHERE Td.HireDate < @EndDate --EndDate 
	AND ( Td.termdate IS NULL OR TD.TermDate > @StartDate) --StartDate
	AND tStatus.IsAllowTime = 1

GROUP BY BU.NxBaseUserID, BU.BaseUserName, tkpr.tkprindex, WorkDate, 
	WC.HoursPerWeek, WC.HoursSunday, WC.HoursMonday, WC.HoursTuesday, WC.HoursWednesday, WC.HoursThursday, WC.HoursFriday, WC.HoursSaturday, WC.Description

ORDER BY BU.NxBaseUserID, TC.WorkDate

END
