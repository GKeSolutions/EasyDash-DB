IF OBJECT_ID('[ed].[GetMissingTimeUsersPerTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetMissingTimeUsersPerTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE ed.GetMissingTimeUsersPerTemplate
		@TemplateId int
	AS
	BEGIN
		Declare @Role INT
		Select * FROM [ed].[NotificationTemplate]
	END
GO
