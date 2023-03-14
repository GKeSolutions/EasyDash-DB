If OBJECT_ID('[ed].[GetUserNameByNetworkAlias]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetUserNameByNetworkAlias] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetUserNameByNetworkAlias]
	@NetworkAlias NVARCHAR(64) = NULL
    AS
    BEGIN
        Declare @UserName VARCHAR(64) = Null
        
		SELECT @UserName = baseUser.BaseUserName
		FROM dbo.NxFWKUser fwkUser 
		JOIN dbo.NxBaseUser baseUser ON baseUser.NxBaseUserID = fwkUser.NxFWKUserID
		WHERE fwkUser.NetworkAlias = @NetworkAlias

		SELECT @UserName UserName
END