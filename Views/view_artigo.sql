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
IF( OBJECT_ID('trg_Insert_Artigo') IS NOT NULL) DROP TRIGGER trg_Insert_Artigo 
GO
CREATE TRIGGER trg_Insert_Artigo
ON Artigo
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
ROLLBACK
GO
-----
IF( OBJECT_ID('trg_Delete_Artigo') IS NOT NULL) DROP TRIGGER trg_Delete_Artigo 
GO
CREATE TRIGGER trg_Delete_Artigo
ON Artigo
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM deleted INNER JOIN _Conferencia ON 
				deleted.nome_conferencia = nome AND
				deleted.ano_conferencia = ano
				WHERE deleted.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	DELETE FROM _Ficheiro FROM _Ficheiro INNER JOIN deleted AS del ON
		_Ficheiro.id_artigo = del.id

	IF EXISTS(SELECT * FROM Autor INNER JOIN deleted ON Autor.id_artigo = deleted.id)
		DELETE FROM Autor WHERE EXISTS(SELECT id_artigo, email_autor FROM _Autor INNER JOIN deleted AS del ON _Autor.id_artigo = del.id)
	
	IF EXISTS(SELECT * FROM Revisao INNER JOIN deleted ON Revisao.id_artigo = deleted.id)
		DELETE FROM Revisao WHERE EXISTS(SELECT id_artigo, email_revisor FROM _Revisao INNER JOIN deleted AS del ON _Revisao.id_artigo = del.id)
	
	IF EXISTS(SELECT * FROM Revisor INNER JOIN deleted ON Revisor.id_artigo = deleted.id)
		DELETE FROM Revisor WHERE EXISTS(SELECT id_artigo, email_revisor FROM _Revisor INNER JOIN deleted AS del ON _Revisor.id_artigo = del.id)
	

	DELETE _Artigo FROM _Artigo INNER JOIN deleted AS del ON
		_Artigo.id = del.id

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

	IF EXISTS( SELECT * FROM inserted INNER JOIN deleted ON 
				deleted.nome_conferencia = inserted.nome_conferencia AND
				deleted.ano_conferencia = inserted.ano_conferencia
				INNER JOIN _Conferencia ON
				deleted.nome_conferencia = _Conferencia.nome AND
				deleted.ano_conferencia = _Conferencia.ano
				WHERE inserted.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	UPDATE _Artigo SET
		resumo = inserted.resumo,
		dataSubmissao = inserted.dataSubmissao
	FROM inserted INNER JOIN deleted ON inserted.id = deleted.id WHERE _Artigo.id = deleted.id

COMMIT
GO