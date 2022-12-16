IF TYPE_ID('[ed].[IdListGui]') IS NULL
	CREATE TYPE [ed].[IdListGui] AS TABLE(
		[Id] [uniqueidentifier] NOT NULL
	)