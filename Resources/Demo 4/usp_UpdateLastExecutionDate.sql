DROP PROCEDURE IF EXISTS [dbo].[usp_UpdateLastExecutionDate]
GO

CREATE PROC [dbo].[usp_UpdateLastExecutionDate] @ExecutionDate datetime AS
UPDATE 
	ControlTable 
SET 
	ExecutionDate = @ExecutionDate
GO
