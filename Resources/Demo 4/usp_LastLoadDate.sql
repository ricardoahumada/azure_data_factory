/****** Object:  StoredProcedure [dbo].[usp_LastLoadDate]    Script Date: 6/18/2018 3:22:31 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_LastLoadDate]
GO

CREATE PROC [dbo].[usp_LastLoadDate] (@Name varchar(50)) as
Select ExecutionDate FROM dbo.ControlTable WHERE Source = @Name
GO

