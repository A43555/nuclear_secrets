USE Conferencias_DB
GO

IF OBJECT_ID('Add_Artigo') IS NOT NULL
	DROP PROCEDURE Add_Artigo
GO

CREATE PROCEDURE Add_Artigo
	@email_autor VARCHAR(50),
	@id_artigo VARCHAR(50),
	@id_ficheiro INT,
	@texto_ficheiro VARCHAR (50),
	@resumo_artigo VARCHAR (50),
	@estado_artigo VARCHAR (50),
	@nome_conferencia VARCHAR(50),
	@ano_conferencia VARCHAR (50),
	@data_sublissao_artigo VARCHAR(50)
AS
	BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	INSERT INTO _Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao) 
		VALUES (@id_artigo, @resumo_artigo, @estado_artigo, @nome_conferencia, @ano_conferencia, @data_sublissao_artigo)

	 INSERT INTO Autor(email_autor, id_artigo) VALUES(@email_autor, @id_artigo)
	 INSERT INTO Ficheiro(id, texto, id_artigo) VALUES(@id_ficheiro, @texto_ficheiro, @id_artigo)

	COMMIT
GO