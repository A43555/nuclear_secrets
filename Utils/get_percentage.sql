USE Conferencias_DB
GO

IF OBJECT_ID('Accepted_Percent') IS NOT NULL
	DROP PROCEDURE Accepted_Percent
GO

CREATE PROCEDURE Accepted_Percent
	@nomeConf VARCHAR(50),
	@anoConf INT,
	@result INT OUTPUT
AS
	BEGIN TRANSACTION
	SET XACT_ABORT ON
	SET NOCOUNT ON

	DECLARE @cntAccept INT
	SELECT @cntAccept = (COUNT(id)) FROM _Artigo WHERE nome_conferencia = @nomeConf AND ano_conferencia = @anoConf AND estado = 'aceite'

	DECLARE @cntReject INT
	SELECT @cntReject = (COUNT(id)) FROM _Artigo WHERE nome_conferencia = @nomeConf AND ano_conferencia = @anoConf AND estado = 'rejeitado'

	DECLARE @cntTotal INT
	SET @cntTotal = @cntAccept + @cntReject
	SET @result = (@cntAccept / @cntTotal) * 100
	COMMIT

GO