
DROP PROC IF EXISTS dbo.usp_InsertLastModifiedDate
GO

CREATE PROC [dbo].[usp_InsertLastModifiedDate] 
	(@FileName varchar(50), @ModifiedDate datetime, @RecordInsertDate datetime)
AS	
INSERT INTO dbo.AzureMetadataTest (FileName, LastModifiedDate, RecordInsertDate)
VALUES (@FileName, @ModifiedDate, @RecordInsertDate);
GO
