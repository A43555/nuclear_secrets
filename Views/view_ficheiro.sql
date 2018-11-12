USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Ficheiro') IS NOT NULL) DROP VIEW Ficheiro 
GO
CREATE VIEW Ficheiro
AS
	SELECT 
		id,
		texto,
		id_artigo
	FROM _Ficheiro
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Ficheiro') IS NOT NULL) DROP VIEW trg_Insert_Ficheiro 
GO
CREATE TRIGGER trg_Insert_Ficheiro
ON Ficheiro
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	INSERT INTO _Ficheiro(id,id_artigo,texto)
		SELECT id, id_artigo, texto 
		FROM inserted

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Ficheiro') IS NOT NULL) DROP VIEW trg_Delete_Ficheiro 
GO
CREATE TRIGGER trg_Delete_Ficheiro
ON Ficheiro
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM deleted INNER JOIN _Artigo ON deleted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	DELETE FROM _Ficheiro FROM _Ficheiro INNER JOIN deleted AS del ON
		_Ficheiro.id = del.id

ROLLBACK
GO
-----
IF( OBJECT_ID('trg_Update_Ficheiro') IS NOT NULL) DROP TRIGGER trg_Update_Ficheiro
GO
CREATE TRIGGER trg_Update_Ficheiro
ON Ficheiro
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM deleted INNER JOIN _Artigo ON deleted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	UPDATE _Ficheiro SET
		texto	=	(SELECT		texto	FROM	inserted)
	WHERE 
		id		=	(SELECT		id	FROM	deleted)

COMMIT
GO