IF OBJECT_ID('[ed].[GetIdleUsersPerProcessAndRole]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetIdleUsersPerProcessAndRole] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
    ALTER PROCEDURE [ed].[GetIdleUsersPerProcessAndRole]
	@ProcessCode NVARCHAR(64) = NULL
	, @idleDays INT
    , @RoleId UNIQUEIDENTIFIER
    AS
    BEGIN
        SET NOCOUNT ON;
        SELECT
            bu.BaseUserName UserName,
            bu.NxBaseUserID UserId,
            ISNULL(msg.Msg, pit.[Name]) ProcessCaption,
            pis.CreateDateTime LastUpdated,
            pis.ProcItemID ProcessItemId,
            pit.ProcCode ProcessCode,
            pit.Name ProcessDescription,
            u.EmailAddr UserEmail
        FROM NxFWKProcessItemStep pis
            JOIN NxBaseUser bu ON bu.NxBaseUserID = pis.CurrentUserId
            JOIN NxFWKUser u ON u.NxFWKUserID = bu.NxBaseUserID		
			JOIN dbo.NxRoleUser rl ON rl.UserID = u.NxFWKUserID
			JOIN dbo.NxRole r ON r.NxRoleID = rl.roleid
            JOIN NxFWKProcessItem pit ON pit.ProcItemID = pis.ProcItemID
            JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = pit.ProcCode
            JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
            LEFT OUTER JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
        WHERE ObjectType.AppObjectTypeCode = 'Process' 
			AND pit.ProcCode =   CASE WHEN @ProcessCode IS NULL THEN pit.ProcCode ELSE @ProcessCode END
            AND EndDateTime IS NULL
			AND DATEDIFF(Minute, pis.CreateDateTime, GETDATE()) > @idleDays * 60  * 24 -- Convert the number of idle days to minutes
			AND r.NxRoleID = @RoleId
END