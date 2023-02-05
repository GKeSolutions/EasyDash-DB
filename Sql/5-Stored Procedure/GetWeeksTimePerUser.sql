IF OBJECT_ID('[ed].[GetWeeksTimePerUser]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetWeeksTimePerUser] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO

--Exec [ed].[GetWeeksTimePerUser] '2022-10-02', '2022-12-24', '32A03368-76B6-4602-A6DA-ACDC76024A64'

ALTER PROCEDURE [ed].[GetWeeksTimePerUser]
	@StartDate DateTime
	, @EndDate DateTime
	, @UserId UniqueIdentifier
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
	ISNULL(WC.Description, 'Work Cakendar Not Set') Workcalendar,
	u.EmailAddr EmailAddress, 
	Weeks.WeekStartDate, 
	Weeks.WeekEndDate
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
Inner Join (Select PeriodDate As WeekStartDate, DATEADD(DAY,  6, PeriodDate) AS WeekEndDate
			From dbo.PeriodNameDay 
			Where PeriodDate Between @StartDate and @EndDate
			And DATENAME(WEEKDAY, PeriodDate) = 'Sunday') As Weeks --Retuns the start and end dates of each week in the period.
			On pDay.PeriodDate >= Weeks.WeekStartDate And pDay.PeriodDate <= Weeks.WeekEndDate
WHERE (Td.HireDate IS NULL OR Td.HireDate < @EndDate)  --EndDate 
	AND ( Td.termdate IS NULL OR TD.TermDate > @StartDate) --StartDate
	AND pDay.PeriodDate > = @StartDate --StartDate
	AND pDay.PeriodDate <= @EndDate --EndDate
	AND (td.HireDate IS NULL Or pDay.PeriodDate >= td.HireDate) -- Exclude days Prior to the employee hiring date
	AND (td.TermDate IS NULL Or pDay.PeriodDate <= td.TermDate) -- Exclude days Post the employee termination date
	AND tStatus.IsAllowTime = 1

GROUP BY BU.NxBaseUserID, BU.BaseUserName, tkpr.tkprindex, Weeks.WeekStartDate, Weeks.WeekEndDate,
	WC.HoursPerWeek, WC.HoursSunday, WC.HoursMonday, WC.HoursTuesday, WC.HoursWednesday, WC.HoursThursday, WC.HoursFriday, WC.HoursSaturday, WC.Description, u.EmailAddr
Having BU.NxBaseUserId = @UserId
ORDER BY BU.NxBaseUserID, Weeks.WeekStartDate

END
