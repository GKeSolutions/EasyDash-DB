IF OBJECT_ID('[ed].[GetScheduledNotification]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetScheduledNotification] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GetScheduledNotification]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
		NS.[ID]
      ,NS.[IsActive]
      ,NS.[NotificationTemplate]
      ,NS.[Scheduler]
      ,NS.[NotifyAfterDays]
      ,NS.[ReassignTo]
      ,NS.[IsCancelProcess]
      ,NS.[CcContact]
	  ,NT.[Type] As [NotificationType]
  FROM [ed].[ScheduledNotification] NS
  Join [ed].NotificationTemplate NT on NT.id = NS.NotificationTemplate
END