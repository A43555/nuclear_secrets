USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Artigo') IS NOT NULL) DROP VIEW Artigo 
GO
CREATE VIEW Artigo
AS
	SELECT 
		id,
		resumo,
		estado,
		nome_conferencia,
		ano_conferencia, 
		dataSubmissao
	FROM _Artigo
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Artigo') IS NOT NULL) DROP VIEW trg_Insert_Artigo 
GO
CREATE TRIGGER trg_Insert_Artigo
ON Artigo
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
ROLLBACK
GO
-----
IF( OBJECT_ID('trg_Delete_Artigo') IS NOT NULL) DROP VIEW trg_Delete_Artigo 
GO
CREATE TRIGGER trg_Delete_Artigo
ON Artigo
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM deleted INNER JOIN _Conferencia ON 
				deleted.nome_conferencia = nome AND
				deleted.ano_conferencia = ano
				WHERE deleted.dataSubmissao < _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	DELETE FROM _Ficheiro FROM _Ficheiro INNER JOIN deleted AS del ON
		_Ficheiro.id_artigo = del.id

	DELETE FROM _Autor FROM _Autor INNER JOIN deleted AS del ON
		_Autor.id_artigo = del.id

	DELETE FROM _Revisao FROM _Revisao INNER JOIN deleted AS del ON
		_Revisao.id_artigo = del.id

	DELETE FROM _Revisor FROM _Revisor INNER JOIN deleted AS del ON
		_Revisor.id_artigo = del.id



	UPDATE _Registo SET posicao = 'presidente'
		FROM _Registo  INNER JOIN  inserted ON
			id_utilizador = dbo.fun_get_id(inserted.email_presidente) INNER JOIN
		deleted ON
			nome_conferencia	=	deleted.nome AND
			ano_conferencia		=	deleted.ano 



COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Artigo') IS NOT NULL) DROP TRIGGER trg_Update_Artigo 
GO
CREATE TRIGGER trg_Update_Artigo
ON Artigo
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Artigo SET
		resumo = inserted.resumo,
		dataSubmissao = inserted.dataSubmissao
	FROM inserted INNER JOIN deleted ON inserted.id = deleted.id WHERE _Artigo.id = deleted.id

COMMIT
GO