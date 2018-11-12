USE Conferencias_DB
GO

IF OBJECT_ID('Add_Registo') IS NOT NULL
	DROP PROCEDURE Add_Registo
GO

CREATE PROCEDURE Add_Registo
	@id_utilizador INT,
	@nome_Conferencia VARCHAR(50),
	@ano_conferencia VARCHAR(50)
AS
	BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	INSERT INTO _Registo(id_utilizador, nome_conferencia, ano_conferencia, posicao)
		VALUES (@id_utilizador, @nome_Conferencia, @ano_conferencia, 'utilizador')
	COMMIT
GO

IF OBJECT_ID('Remove_Registo') IS NOT NULL
	DROP PROCEDURE Remove_Registo
GO

CREATE PROCEDURE Remove_Registo
	@id_utilizador INT,
	@nome_Conferencia VARCHAR(50),
	@ano_conferencia VARCHAR(50)
AS
	BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	DECLARE @posicao VARCHAR(50)

	SELECT @posicao = posicao FROM _Registo WHERE 
		id_utilizador = @id_utilizador AND 
		nome_conferencia = @nome_Conferencia AND 
		ano_conferencia = @ano_conferencia

	IF @posicao != 'utilizador'
		DELETE FROM _Registo WHERE 
			id_utilizador = @id_utilizador AND 
			nome_conferencia = @nome_Conferencia AND 
			ano_conferencia = @ano_conferencia
	COMMIT
GO