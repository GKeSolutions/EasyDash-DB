IF OBJECT_ID('[ed].[GetOpenProcessesPerTemplate]','P') IS NULL
	EXEC('CREATE PROCEDURE [ed].[GetOpenProcessesPerTemplate] WITH ENCRYPTION AS BEGIN SELECT NULL; END;');
GO
	ALTER PROCEDURE ed.[GetOpenProcessesPerTemplate]
		@TemplateId int
	AS
	BEGIN
		Declare @RoleId UniqueIdentifier, @ProcessCode Varchar(64), @AfterDays INT

		Select @RoleId = Role
		,@ProcessCode = Process
		,@AfterDays = NotifyAfterDays
		FROM [ed].[NotificationTemplate] nt
		Join [ed].ScheduledNotification sn on sn.NotificationTemplate = nt.ID
		Where nt.ID = @TemplateId
		
		SELECT
            Distinct bu.BaseUserName UserName,
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
            JOIN NxFWKProcessItem pit ON pit.ProcItemID = pis.ProcItemID
            JOIN dbo.NxFWKAppObject Appobject ON Appobject.AppObjectCode = pit.ProcCode
            JOIN dbo.NxFWKAppObjectType ObjectType ON ObjectType.NxFWKAppObjectTypeID = Appobject.AppObjectTypeId
            LEFT OUTER JOIN dbo.nxmsg msg ON msg.MsgId = appobject.AppObjectCaptionId AND msg.LanguageIndex = 1033 -- English langauage
        WHERE ObjectType.AppObjectTypeCode = 'Process' 
            AND pis.EndDateTime IS NULL
			And pis.StartDateTime < DATEADD(Day, -@AfterDays, GetDate()) And pis.StartDateTime > DATEADD(Day, -(@AfterDays +1), GetDate()) -- Notify on on the day selected. Stop notifying the following days
			And (@RoleId Is NUll Or bu.NxBaseUserID in (Select rl.UserId 
														From dbo.NxRoleUser	rl
														Where rl.roleid = @RoleId)
				)
			And (@ProcessCode Is Null Or pit.ProcCode = @ProcessCode)
	END
GO
