
IF OBJECT_ID('dbo.prc_CutOff') IS NOT NULL
	DROP PROCEDURE dbo.prc_CutOff
GO
CREATE PROCEDURE dbo.prc_CutOff
	@id INT,
	@cutOff INT = 50
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	DECLARE @tables TABLE(id INT, nome_conferencia VARCHAR(50), ano_conferencia INT, resumo VARCHAR(50), dataSubmissao DATE, estado VARCHAR(15) )
	DECLARE @allTables TABLE(id INT, nome_conferencia VARCHAR(50), ano_conferencia INT, resumo VARCHAR(50), dataSubmissao DATE, estado VARCHAR(15) )

	INSERT INTO @allTables(id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado) SELECT id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado
		FROM _Artigo WHERE _Artigo.id= @id

	INSERT INTO @allTables(id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado) SELECT id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado
		FROM @allTables EXCEPT SELECT id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado FROM _Artigo INNER JOIN _Revisao ON _Revisao.id_artigo = _Artigo.id
			WHERE( (SELECT AVG(nota) FROM _Revisao) < @cutOff)

	SELECT * FROM @tables

	UPDATE _Artigo SET estado = 'aceite' FROM _Artigo INNER JOIN _Revisao as rev ON
		_Artigo.id = rev.id_artigo
		WHERE EXISTS(SELECT * FROM @tables)

	UPDATE _Artigo SET estado = 'rejeitado' FROM _Artigo INNER JOIN _Revisao as rev ON
		_Artigo.id = rev.id_artigo
		WHERE EXISTS((SELECT id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado
			FROM _Artigo WHERE _Artigo.id= @id) EXCEPT SELECT id,nome_conferencia,ano_conferencia,resumo,dataSubmissao,estado FROM @tables)
GO

	