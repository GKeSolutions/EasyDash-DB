IF OBJECT_ID('[ed].[GeScheduler]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GeScheduler] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[GeScheduler]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
		[ID]
      , CronExpression
      , [Description]
  FROM [ed].[Scheduler]
END