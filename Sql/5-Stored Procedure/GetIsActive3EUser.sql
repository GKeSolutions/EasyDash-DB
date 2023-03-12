If OBJECT_ID('[ed].[GetIsActive3EUser]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetIsActive3EUser] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetIsActive3EUser]
	@NetworkAlias NVARCHAR(64) = NULL
    AS
    BEGIN
        Declare @IsActive3EUser BIT = 0
        
		SELECT @IsActive3EUser = ISNULL(baseUser.IsActive, 0)
		FROM dbo.NxFWKUser fwkUser 
		JOIN dbo.NxBaseUser baseUser ON baseUser.NxBaseUserID = fwkUser.NxFWKUserID
		WHERE fwkUser.NetworkAlias = @NetworkAlias

		SELECT @IsActive3EUser IsActive3EUser
END