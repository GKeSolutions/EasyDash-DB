IF OBJECT_ID('[ed].[CreateTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[CreateTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[CreateTemplate] 
	@IsActive BIT
	, @Description NVARCHAR(100)
	, @Type INT
	, @Priority INT
	, @Role uniqueidentifier
	, @Process NVARCHAR(100)
	, @TemplateSubject NVARCHAR(500)
	, @TemplateBody NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO [ed].[NotificationTemplate]
			   ([IsActive]
			   ,[Description]
			   ,[Type]
			   ,[Priority]
			   ,[Role]
			   ,[Process]
			   ,[TemplateSubject]
			   ,[TemplateBody])
		 VALUES
			   (@IsActive
			   , @Description
			   , @Type
			   , @Priority
			   , @Role
			   , @Process
			   , @TemplateSubject
			   , @TemplateBody);
		COMMIT;
		DECLARE @NewId INT = SCOPE_IDENTITY();
		SELECT ID, IsActive, Description, Type, Priority, Role, Process, TemplateSubject, TemplateBody FROM [ed].[NotificationTemplate] WHERE ID = @NewId
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new template', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO