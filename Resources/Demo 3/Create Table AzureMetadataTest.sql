/****** Object:  Table [dbo].[AzureMetadataTest]    Script Date: 6/18/2018 1:25:50 PM ******/
DROP TABLE IF EXISTS dbo.[AzureMetadataTest]
GO

CREATE TABLE [dbo].[AzureMetadataTest](
	[FileName] VARCHAR(50) NULL,
	[LastModifiedDate] [datetime] NULL,
	[RecordInsertDate] [datetime] NULL
) ON [PRIMARY]
GO


