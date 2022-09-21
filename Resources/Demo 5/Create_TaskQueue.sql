DROP TABLE IF EXISTS dbo.TaskQueue
GO

CREATE TABLE [dbo].[TaskQueue](
	[FileName] [varchar](100) NULL,
	[Status] [int] NULL,
	[InsertDate] [datetime] NULL
) ON [PRIMARY]
GO


