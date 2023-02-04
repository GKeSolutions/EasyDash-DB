IF OBJECT_ID('[ed].[GetMissingTimePerUserPerWeek]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetMissingTimePerUserPerWeek] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GetMissingTimePerUserPerWeek]
	@WeekStartDate DateTime
	, @WeekEndDate DateTime
	, @UserId uniqueidentifier
AS
BEGIN
SELECT 
	BU.NxBaseUserID UserId,
	BU.BaseUserName UserName,
	tkpr.tkprindex TimekeeperIndex,
	SUM(Isnull(WorkHrs, 0)) WorkHrs,
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
	u.EmailAddr EmailAddress
FROM dbo.Timekeeper tkpr
	JOIN dbo.PeriodNameDay pDay on 1 = 1 --joining on PeriodNameDay to get the list of days
	JOIN Tkprstatus tStatus ON tStatus.Code = tkpr.TkprStatus
	JOIN TkprDate td ON td.TimekeeperLkUp = tkpr.tkprindex AND GETDATE() BETWEEN td.NxStartDate AND td.NxEndDate
	LEFT OUTER JOIN dbo.WorkCalendar WC ON td.WorkCalendar = WC.Code
	JOIN dbo.NxUserTimekeeper UT ON UT.Timekeeper = tkpr.tkprindex AND UT.IsDefault = 1
	JOIN dbo.NxBaseUser BU ON BU.NxBaseUserID = UT.UserID
	JOIN NxFWKUser u ON u.NxFWKUserID = bu.NxBaseUserID
	LEFT OUTER JOIN dbo.Timecard TC ON Tc.Timekeeper = tkpr.TkprIndex and tc.WorkDate = pDay.PeriodDate
		AND (TC.IsActive IS NULL OR TC.IsActive = 1)
WHERE BU.NxBaseUserID=@UserID
	AND (Td.HireDate IS NULL OR Td.HireDate < @WeekEndDate)  --EndDate 
	AND ( Td.termdate IS NULL OR TD.TermDate > @WeekStartDate) --StartDate
	AND pDay.PeriodDate > = @WeekStartDate --StartDate
	AND pDay.PeriodDate <= @WeekEndDate --EndDate
	AND (td.HireDate IS NULL Or pDay.PeriodDate >= td.HireDate) -- Exclude days Prior to the employee hiring date
	AND (td.TermDate IS NULL Or pDay.PeriodDate <= td.TermDate) -- Exclude days Post the employee termination date
	AND tStatus.IsAllowTime = 1

GROUP BY BU.NxBaseUserID, BU.BaseUserName, tkpr.tkprindex,
	WC.HoursPerWeek, WC.HoursSunday, WC.HoursMonday, WC.HoursTuesday, WC.HoursWednesday, WC.HoursThursday, WC.HoursFriday, WC.HoursSaturday, WC.Description, u.EmailAddr

ORDER BY BU.NxBaseUserID

END
