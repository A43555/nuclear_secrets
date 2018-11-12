USE Conferencias_DB

IF( OBJECT_ID('prc_Get_Available_Revisores') IS NOT NULL) DROP PROCEDURE prc_Get_Available_Revisores 
GO
CREATE PROCEDURE prc_Get_Available_Revisores
	@nome_conf VARCHAR(50),
	@ano_conf INT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	SELECT email FROM Registo WHERE nome_conferencia = @nome_conf AND ano_conferencia = @ano_conf
	COMMIT
GO