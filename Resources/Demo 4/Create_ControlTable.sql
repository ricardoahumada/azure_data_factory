/****** Object:  Table [dbo].[ControlTable]    Script Date: 6/18/2018 3:18:56 PM ******/
DROP TABLE IF EXISTS [dbo].[ControlTable]
GO

CREATE TABLE [dbo].[ControlTable](
	[Source] [varchar](50) NULL,
	[ExecutionDate] [datetime] NULL
) ON [PRIMARY]
GO

INSERT INTO dbo.ControlTable (Source, ExecutionDate)
VALUES('inputEmp_tq.txt', '2021-06-13 12:00:00.000')

