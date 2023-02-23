IF OBJECT_ID('[ed].[GetAllUsersAndRoles]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetAllUsersAndRoles] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].GetAllUsersAndRoles

    AS
    BEGIN
        SET NOCOUNT ON;
		SELECT NxBaseUserId, 
				BaseUserName, 
				IsActive, 
				ArchetypeCode 
		From NxBaseUser
END