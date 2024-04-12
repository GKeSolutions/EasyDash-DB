IF OBJECT_ID('[ed].[Create3EMatterNote]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[Create3EMatterNote] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
ALTER PROCEDURE [ed].[Create3EMatterNote]  
	@MatterIndex Integer
	, @EntryUserId UNIQUEIDENTIFIER
	, @Note NVARCHAR(4000)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO [dbo].[MattNote]
				([MattNoteId]
				,[Matter]
				,[MattNoteType]
				,[DateEntered]
				,[EntryUser]
				,[Note]
				,[ArchetypeCode]
				,[HasAttachments]
				,[TimeStamp])
		 VALUES
			   (NEWID()
			   , @MatterIndex
			   , 'Collect'
			   ,GETDATE()
			   ,@EntryUserId
			   ,@Note 
			   ,'MattNote'
			   ,0
			   ,GETDATE())
		COMMIT;
	END TRY
	BEGIN CATCH
		RAISERROR('Failed to create new Matter Note', 16, 1)
		ROLLBACK TRANSACTION
	END CATCH
END
GO
