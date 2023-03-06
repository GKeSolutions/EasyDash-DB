IF OBJECT_ID('[ed].[GetRolesPerNetworkAlias]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetRolesPerNetworkAlias] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetRolesPerNetworkAlias]
	@NetworkAlias NVARCHAR(64) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;
		SELECT Distinct
			role.NxRoleID RoleId, 
			role.Description RoleDecription
		From nxfwkuser fwkUser 
		Join NxRoleUser roleUser on roleUser.UserID = fwkUser.NxFWKUserID
		Join NxRole role on role.NxRoleID = roleUser.RoleID
		Where fwkUser.NetworkAlias = @NetworkAlias
END