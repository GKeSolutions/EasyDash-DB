IF OBJECT_ID('[ed].[IsSchedulerLinked]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[IsSchedulerLinked] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE [ed].[IsSchedulerLinked] 
		@SchedulerId INT
	AS
	BEGIN
		SELECT s.Id, s.IsActive, n.[Type] EventType FROM ed.ScheduledNotification s
		JOIN ed.NotificationTemplate n ON n.ID=s.NotificationTemplate
		WHERE Scheduler=@SchedulerId
END