IF OBJECT_ID('[ed].[GeNotificationScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GeNotificationScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GeNotificationScheduler]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
		[ID]
      ,[IsActive]
      ,[NotificationTemplate]
      ,[Schedule]
      ,[NotifyAfterDays]
      ,[ReassignTo]
      ,[CcContact]
  FROM [ed].[NotificationScheduler]
END