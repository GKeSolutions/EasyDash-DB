If OBJECT_ID('[ed].[GetUserIdByNetworkAlias]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetUserIdByNetworkAlias] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetUserIdByNetworkAlias]
	@NetworkAlias NVARCHAR(64) = NULL
    AS
    BEGIN
        Declare @UserId UniqueIdentifier = Null
        
		SELECT @UserId = baseUser.NxBaseUserId
		FROM dbo.NxFWKUser fwkUser 
		JOIN dbo.NxBaseUser baseUser ON baseUser.NxBaseUserID = fwkUser.NxFWKUserID
		WHERE fwkUser.NetworkAlias = @NetworkAlias

		SELECT @UserId UserId
END