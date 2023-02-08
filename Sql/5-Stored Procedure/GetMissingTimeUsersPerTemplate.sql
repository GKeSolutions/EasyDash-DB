IF OBJECT_ID('[ed].[GetMissingTimeUsersPerTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetMissingTimeUsersPerTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE ed.GetMissingTimeUsersPerTemplate
		@TemplateId int
	AS
	BEGIN
		Declare @RoleId uniqueidentifier, @StartDate DateTime, @EndDate DateTime
		Select @RoleId = nt.Role FROM [ed].[NotificationTemplate] nt

		Select @EndDate = MAX(PeriodDate), @StartDate = DATEADD(DAY, -6, MAX(PeriodDate))
		From dbo.PeriodNameDay
		Where PeriodDate<GetDate()
			And DATENAME(WEEKDAY, PeriodDate) = 'Saturday'
		 
		If @RoleId IS NULL
			EXEC [ed].[GetMissingTimeUsers] @StartDate, @EndDate
		Else
			EXEC [ed].[GetMissingTimeUsersPerRole] @StartDate, @EndDate, @RoleId
	END
GO
