
DROP PROC IF EXISTS dbo.usp_InsertFileNames
GO

CREATE PROC [dbo].[usp_InsertFileNames] 
	(@filename varchar(50), @Status int = 0, @DateInserted datetime)
AS
INSERT INTO TaskQueue (FileName, Status, InsertDate)
VALUES(@filename, @Status, @DateInserted)
GO


